use rand::Rng;
use std::cmp::Ordering;

fn main() {
    let mut arr: Vec<i32> = (0..100).collect();

    let mut rng = rand::thread_rng();
    arr.sort_by(|_, _| {
        if rng.gen::<bool>() {
            Ordering::Less
        } else {
            Ordering::Greater
        }
    });

    println!("{:?}", arr);
}
