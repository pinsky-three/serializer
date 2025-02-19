use uuid::Uuid;

fn main() {
    let uuid = Uuid::now_v7();

    println!("Hello, world! {}", uuid);
}
