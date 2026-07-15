use rand::Rng;
use std::cmp::Ordering;
use std::env;

fn main() {
    let n: usize = env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(100);
    let mut arr: Vec<i32> = (0..n).map(|x| x as i32).collect();

    let mut rng = rand::thread_rng();
    arr.sort_by(|_, _| {
        if rng.gen::<bool>() {
            Ordering::Less
        } else {
            Ordering::Greater
        }
    });

    let limit = arr.len().min(100);
    println!("{:?}", &arr[..limit]);
}
