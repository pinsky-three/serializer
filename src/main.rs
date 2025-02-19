use serde::Deserialize;
use std::error::Error;

use uuid::Uuid;

#[derive(Debug, Deserialize, Clone)]
struct InputRow {
    artwork_name: String,
    // artwork_category: String,
    // artwork_image_path: String,
    batch_production: u32,
}

fn main() -> Result<(), Box<dyn Error>> {
    let mut input_csv = csv::Reader::from_path("input/input.csv")?;

    for result in input_csv.deserialize() {
        let record: InputRow = result?;

        // let a = record.clone().artwork_name;

        for _i in 0..record.batch_production {
            let uuid = Uuid::now_v7();
            println!("[{}] {}", uuid, record.artwork_name);
        }

        println!();

        // println!("{:?}", record);
    }

    // for result in input_csv.records() {
    //     let record = result?;
    //     println!("{:?}", record);
    // }

    // let uuid = Uuid::now_v7();

    // println!("Hello, world! {}", uuid);

    Ok(())
}
