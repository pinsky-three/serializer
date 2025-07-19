use drive_v3::Credentials;
use drive_v3::Drive;
// use itertools::repeat_n;
// use itertools::Itertools;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::env;
use std::error::Error;
use std::path::PathBuf;
use std::process::Command;
// use std::time::Duration;
use std::time::Instant;

use uuid::Uuid;

#[derive(Debug, Deserialize, Clone)]
struct InputRow {
    batch_production: u32,

    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
    artwork_format: String,
    artwork_material: String,
    artwork_orientation: String,
    artwork_technique_es: String,
    artwork_technique_en: String,
    artwork_short_description_es: String,
    artwork_short_description_en: String,
    qr_link: String,
}

#[derive(Debug, Serialize, Clone)]
struct OutputRow {
    id: Uuid,

    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
    artwork_format: String,
    artwork_material: String,
    artwork_orientation: String,
    artwork_technique_es: String,
    artwork_technique_en: String,
    artwork_short_description_es: String,
    artwork_short_description_en: String,
    qr_link: String,
}

fn main() -> Result<(), Box<dyn Error>> {
    let output_path = "output/output.csv";
    let input_path = "input/input.csv";

    std::fs::create_dir_all(std::path::Path::new(output_path).parent().unwrap())?;

    let mut input_csv = csv::Reader::from_path(input_path)?;
    let mut output_csv = csv::Writer::from_path(output_path)?;

    let client_secrets_path = "credentials/client_secret_199454688484-3g32tp6dde29irgn8m0b1a5d6fpfpt9j.apps.googleusercontent.com.json";

    // The OAuth scopes you need
    let scopes: [&'static str; 3] = [
        "https://www.googleapis.com/auth/drive.metadata.readonly",
        "https://www.googleapis.com/auth/drive.file",
        "https://www.googleapis.com/auth/drive",
    ];

    let stored_credentials = "credentials/credentials.json";

    let mut credentials = Credentials::from_file(stored_credentials, &scopes).unwrap();

    if credentials.are_valid() {
        credentials.refresh().unwrap();
    } else {
        credentials = Credentials::from_client_secrets_file(client_secrets_path, &scopes).unwrap();
        credentials.store(stored_credentials).unwrap();
    }

    let drive = Drive::new(&credentials);

    let mut artwork_permutations = HashMap::new();

    for result in input_csv.deserialize() {
        let record: InputRow = result?;

        for _i in 0..record.batch_production {
            // extract "1pyOzBeKhHDnI7Baf8RRPDLEgA2sJXGhT"
            // from "https://drive.google.com/file/d/1pyOzBeKhHDnI7Baf8RRPDLEgA2sJXGhT/view?usp=drive_link"

            // println!("record.artwork_image_path: {}", record.artwork_image_path);

            let id = record.artwork_image_path.split("/").nth(5).unwrap();

            let file = drive.files.get(id).execute().unwrap();

            let file_name = file.name.unwrap();

            let file_image_path = std::path::Path::new("output/").join(&file_name);

            if !file_image_path.exists() {
                let res = drive
                    .files
                    .get_media(id)
                    .save_to(file_image_path.clone())
                    .execute();

                if res.is_err() {
                    println!(
                        "Error downloading file: '{}' with error: {:?}",
                        file_name,
                        res.err()
                    );
                    continue;
                }

                let img = image::open(&file_image_path).unwrap();
                let ratio = img.width() as f32 / img.height() as f32;

                // println!("orientation: {} | ratio: {}", record.orientation, ratio);

                if (record.artwork_orientation == "horizontal" && ratio < 1.0)
                    || (record.artwork_orientation == "vertical" && ratio > 1.0)
                {
                    img.rotate270().save(&file_image_path).unwrap();
                    // println!("rotated: {}", file_image_path.display());
                }
            }

            let uuid = Uuid::now_v7();

            println!("[{}] {}", uuid, record.artwork_name);

            let row = OutputRow {
                id: uuid,

                artwork_image_path: PathBuf::from("..")
                    .join(file_image_path.clone())
                    .to_str()
                    .unwrap()
                    .to_string(),
                artwork_name: record.artwork_name.clone(),
                artwork_category: record.artwork_category.clone(),
                artwork_format: record.artwork_format.clone(),
                artwork_material: record.artwork_material.clone(),
                artwork_orientation: record.artwork_orientation.clone(),
                artwork_technique_es: record.artwork_technique_es.clone(),
                artwork_technique_en: record.artwork_technique_en.clone(),
                artwork_short_description_es: record.artwork_short_description_es.clone(),
                artwork_short_description_en: record.artwork_short_description_en.clone(),
                qr_link: record.qr_link.clone(),
            };

            if file_image_path.extension().unwrap() == "tif" {
                continue;
            }

            output_csv.serialize(row)?;
        }

        artwork_permutations
            .entry(PrintTemplateParams {
                paper_size: record.artwork_format.clone().to_lowercase(),
                orientation: record.artwork_orientation.clone().to_lowercase(),
                material: record.artwork_material.clone().to_lowercase(),
            })
            .and_modify(|e| *e += record.batch_production)
            .or_insert(0);
    }

    output_csv.flush()?;

    std::fs::create_dir_all("prod_output").unwrap_or_else(|_| {
        println!("Error creating directory: prod_output");
    });

    compile_typst_template("print_ax.typ".to_string(), artwork_permutations);
    compile_typst_template_simple("certificate_a6_hor_front.typ".to_string());
    compile_typst_template_simple("certificate_a6_hor_back.typ".to_string());

    Ok(())
}

fn compile_typst_template(
    template_name: String,
    permutations_count: HashMap<PrintTemplateParams, u32>,
) {
    let permutations = permutations_count
        .keys()
        .collect::<Vec<&PrintTemplateParams>>();

    println!("permutations: {:?}", permutations);

    for params in permutations {
        let now = Instant::now();

        let mut command = compile_typst_command(template_name.to_string(), params.to_owned());

        println!("command: {:?}", command);

        command
            .spawn()
            .expect("error at typst running")
            .wait()
            .unwrap();

        println!(
            "Compiled '{}' in: {}ms",
            template_name,
            now.elapsed().as_millis()
        );
    }
}

fn compile_typst_template_simple(template_name: String) {
    let now = Instant::now();

    let mut command = compile_typst_command_simple(template_name.to_string());

    command
        .spawn()
        .expect("error at typst running")
        .wait()
        .unwrap();

    println!(
        "Compiled '{}' in: {}ms",
        template_name,
        now.elapsed().as_millis()
    );
}

#[derive(Debug, PartialEq, Eq, Hash, Clone)]
struct PrintTemplateParams {
    paper_size: String,
    orientation: String,
    material: String,
}

fn compile_typst_command(template_input_filename: String, params: PrintTemplateParams) -> Command {
    let current_dir = env::current_dir().unwrap();

    let mut command = Command::new("typst");

    let mut filename = PathBuf::from(template_input_filename.clone());

    filename.set_extension("");

    println!(
        "Compiling '{}' with params: {:?}",
        template_input_filename, params
    );

    let file_name = filename.file_name().unwrap().to_str().unwrap();

    let material = params.material;
    let orientation = params.orientation;
    let paper_size = params.paper_size;

    let params_suffix = [paper_size.clone(), material.clone(), orientation.clone()].join("_");

    let compiled_output_path = format!("../prod_output/{}_{}.pdf", file_name, params_suffix);

    command.current_dir("prod");
    command.arg("compile");
    command.args(["--root", current_dir.to_str().unwrap()]);
    command.args(["--input", format!("material={}", material).as_str()]);
    command.args(["--input", format!("orientation={}", orientation).as_str()]);
    command.args(["--input", format!("paper_size={}", paper_size).as_str()]);
    command.args(["--font-path", "assets/fonts"]);

    command.arg(template_input_filename);
    command.arg(compiled_output_path);

    command
}

fn compile_typst_command_simple(template_input_filename: String) -> Command {
    let current_dir = env::current_dir().unwrap();

    let mut command = Command::new("typst");

    let mut filename = PathBuf::from(template_input_filename.clone());

    filename.set_extension("");

    println!("Compiling '{}'", template_input_filename);

    let file_name = filename.file_name().unwrap().to_str().unwrap();

    let compiled_output_path = format!("../prod_output/{}.pdf", file_name);

    command.current_dir("prod");
    command.arg("compile");
    command.args(["--root", current_dir.to_str().unwrap()]);
    command.args(["--font-path", "assets/fonts"]);
    command.arg(template_input_filename);
    command.arg(compiled_output_path);

    command
}
