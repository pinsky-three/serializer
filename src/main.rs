use serde::{Deserialize, Serialize};
use std::error::Error;

use uuid::Uuid;

#[derive(Debug, Deserialize, Clone)]
struct InputRow {
    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
    batch_production: u32,
}

#[derive(Debug, Serialize, Clone)]
struct OutputRow {
    id: Uuid,
    artwork_name: String,
    artwork_category: String,
    artwork_image_path: String,
}

fn main() -> Result<(), Box<dyn Error>> {
    let output_path = "output/output.csv";

    std::fs::create_dir_all(std::path::Path::new(output_path).parent().unwrap())?;

    let mut input_csv = csv::Reader::from_path("input/input.csv")?;
    let mut output_csv = csv::Writer::from_path(output_path)?;

    for result in input_csv.deserialize() {
        let record: InputRow = result?;

        // let a = record.clone().artwork_name;

        for _i in 0..record.batch_production {
            let uuid = Uuid::now_v7();
            println!("[{}] {}", uuid, record.artwork_name);

            let row = OutputRow {
                id: uuid,
                artwork_name: record.artwork_name.clone(),
                artwork_category: record.artwork_category.clone(),
                artwork_image_path: record.artwork_image_path.clone(),
            };

            output_csv.serialize(row)?;
        }

        println!();

        // println!("{:?}", record);
    }

    output_csv.flush()?;

    Ok(())
}
