const profiler = require('v8-profiler-next');
const fs = require('fs');

// Start profiling
profiler.startSampling();

// Run your code here
// Example: Your application logic
for (let i = 0; i < 1000000; i++) {
  // Code to profile
}

// Stop profiling
profiler.stop();

// Save results
const results = profiler.buildTree();
fs.writeFileSync('profile.json', JSON.stringify(results, null, 2));

console.log('Profile saved to profile.json');
console.log('Use Chrome DevTools > More > Tools > JavaScript Profiler to analyze');