// Sorting Sins - JavaScript

const n = parseInt(process.argv[2]) || 100;
const arr = Array.from({ length: n }, (_, i) => i);

arr.sort(() => Math.random() - 0.5);

console.log(arr.slice(0, 100));
