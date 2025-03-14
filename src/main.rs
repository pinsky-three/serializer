use drive_v3::Credentials;
use drive_v3::Drive;
use serde::{Deserialize, Serialize};
use std::error::Error;
use std::path::PathBuf;

use uuid::Uuid;

// #[derive(Debug, Deserialize, Serialize, Clone)]
// struct ArtworkData {
//     artwork_name: String,
//     artwork_category: String,
//     artwork_image_path: String,
//     artwork_format: String,
//     artwork_orientation: String,
//     artwork_technique_es: String,
//     artwork_technique_en: String,
//     artwork_short_description_es: String,
//     artwork_short_description_en: String,
// }

#[derive(Debug, Deserialize, Clone)]
struct InputRow {
    batch_production: u32,

    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
    artwork_format: String,
    artwork_orientation: String,
    artwork_technique_es: String,
    artwork_technique_en: String,
    artwork_short_description_es: String,
    artwork_short_description_en: String,
}

#[derive(Debug, Serialize, Clone)]
struct OutputRow {
    id: Uuid,

    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
    artwork_format: String,
    artwork_orientation: String,
    artwork_technique_es: String,
    artwork_technique_en: String,
    artwork_short_description_es: String,
    artwork_short_description_en: String,
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

    for result in input_csv.deserialize() {
        let record: InputRow = result?;

        for _i in 0..record.batch_production {
            // extract "1pyOzBeKhHDnI7Baf8RRPDLEgA2sJXGhT"
            // from "https://drive.google.com/file/d/1pyOzBeKhHDnI7Baf8RRPDLEgA2sJXGhT/view?usp=drive_link"

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
                    println!("Error downloading file: {:?}", res.err());
                    continue;
                }

                let img = image::open(&file_image_path).unwrap();
                let ratio = img.width() as f32 / img.height() as f32;

                // println!("orientation: {} | ratio: {}", record.orientation, ratio);

                if (record.artwork_orientation == "horizontal" && ratio < 1.0)
                    || (record.artwork_orientation == "vertical" && ratio > 1.0)
                {
                    img.rotate270().save(&file_image_path).unwrap();
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
                artwork_orientation: record.artwork_orientation.clone(),
                artwork_technique_es: record.artwork_technique_es.clone(),
                artwork_technique_en: record.artwork_technique_en.clone(),
                artwork_short_description_es: record.artwork_short_description_es.clone(),
                artwork_short_description_en: record.artwork_short_description_en.clone(),
            };

            if file_image_path.extension().unwrap() == "tif" {
                continue;
            }

            output_csv.serialize(row)?;
        }

        // println!();
    }

    output_csv.flush()?;

    Ok(())
}
