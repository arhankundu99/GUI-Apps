# Algo-visualiser
## BFS
Breadth-first search is an algorithm for traversing or searching tree or graph data structures. It starts at the tree root, and explores all of the neighbor nodes at the present depth prior to moving on to the nodes at the next depth level.

### Features
Add source, destination, obstacles and visualise BFS! <br/>
<br/>
<img src="https://media.giphy.com/media/d5qcD2alh3hvGYgJXG/giphy.gif" alt="alt text" height = 500 >
<br/>
Time Complexity: `O(E+V)`
## Merge Sort
<img src="https://media.giphy.com/media/RIGJMHqq3tJ3JwW7Uf/giphy.gif" alt="alt text" height = 500 >
Merge Sort is a Divide and Conquer algorithm. It divides input array in two halves, calls itself for the two halves and then merges the two sorted halves. The merge() function is used for merging two halves. The merge(arr, l, m, r) is key process that assumes that arr[l..m] and arr[m+1..r] are sorted and merges the two sorted sub-arrays into one. <br/>

## Quick Sort
<img src="https://media.giphy.com/media/UoRVGwKjH8VjOSiGpg/giphy.gif" alt="alt text" height = 500 >
Quick sort is a highly efficient sorting algorithm and is based on partitioning of array of data into smaller arrays. A large array is partitioned into two arrays one of which holds values smaller than the specified value, say pivot, based on which the partition is made and another array holds values greater than the pivot value.

Quicksort partitions an array and then calls itself recursively twice to sort the two resulting subarrays.The average and worst-case complexity are `O(nLogn)` and `O(n * n)`, respectively.

## Sudoku
Sudoku is a logic-based, combinatorial number-placement puzzle. In classic sudoku, the objective is to fill a 9×9 grid with digits so that each column, each row, and each of the nine 3×3 subgrids that compose the grid contain all of the digits from 1 to 9. This sudoku game is developed using pygame library and automated using backtracking algorithm

### Features implemented
1) **Game Interface to Play** <br/>
2) **Auto solving** <br/>
3) **Visualization of auto solving i.e., Backtracking Algorithm visualization** <br/>
4) **Options: Reset, Clear game** <br/>
5) **Manual Solving** <br/>

### Screenshots
<img src="images/1.PNG" width="400" height="500">  <img src="images/2.PNG" width="400" height="500">

### Time and Space Complexity
Time complexity of backtracking algorithm is ```O(N^(N * N))``` where N is the grid size <br/>
Space complexity is ```O(N * N)```

## Bubble sort visualiser
Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order. The pass through the list is repeated until the list is sorted.

### Screenshots
<img src="images/5.PNG" width="400" height="400" align="left">  <img src="images/6.PNG" width="400" height="400" aligh="right">

### Time Complexity
Time complexity of bubble sort is ```O(N*N)```

## DFS
Depth-first search is an algorithm for traversing or searching tree or graph data structures. The algorithm starts at the root node and explores as far as possible along each branch before backtracking. <br/>
DFS traverses the graph depthwise. when it reaches a dead end, it backtracks and continues the process

### Features
Add source, destination, obstacles and visualise DFS!

### Screenshots
<img src="images/7.PNG" width="800" height="800">
