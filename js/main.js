// Sorting Sins - JavaScript

const arr = Array.from({ length: 100 }, (_, i) => i);

arr.sort(() => Math.random() - 0.5);

console.log(arr);
