# 8-puzzle-solver

# Missionary-Cannibal-Problem-Solver

The given problem is solved using the A-star algorithm. The heuristic function used is: 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![equation](https://latex.codecogs.com/gif.latex?h%28n%29%3Dnumber%5Chspace%7B0.1cm%7Dof%5Chspace%7B0.1cm%7Dmisplaced%5Chspace%7B0.1cm%7Dtiles)

where n is any arbitrary state.

State space representation
---------------------------

The 3X3 board is represented here as a list of 10 numbers. Each possible board configuration, represented by a state in the 
search space is defined as a 10-tuple:
&nbsp;&nbsp;![equation](https://latex.codecogs.com/gif.latex?%3Ct_1%2Ct_2%2Ct_3%2Ct_4%2Ct_5%2Ct_6%2Ct_7%2Ct_8%2Ct_9%2Cpos%5C_blank%3E)
where, ![equation](https://latex.codecogs.com/gif.latex?t_1%5Chspace%7B0.1cm%7D%2Ct_2%5Chspace%7B0.1cm%7D%2Ct_3%5Chspace%7B0.1cm%7D%2Ct_4%5Chspace%7B0.1cm%7D%2Ct_5%5Chspace%7B0.1cm%7D%2Ct_6%5Chspace%7B0.1cm%7D%2Ct_7%5Chspace%7B0.1cm%7D%2Ct_8%5Chspace%7B0.1cm%7D%2Ct_9) 
represent the tile numbers at the respective positions and ![equation](https://latex.codecogs.com/gif.latex?pos%5C_blank) represents the position of the blank tile in the list. 
Since an apparent 2-D matrix of numbers have been converted to a 1-D list, the first element of the second and third rows in the board are the fourth and the seventh elements in the above given list. Additionally, it should be noted that a blank tile has been represented here as a tile numbered 0 .


Thus according to the given input board configuration ![equation](https://latex.codecogs.com/gif.latex?%28%28E%2C1%2C3%29%284%2C2%2C5%29%287%2C8%2C6%29%29),
the start state is represented as ![equation](https://latex.codecogs.com/gif.latex?%3C0%2C1%20%2C3%2C4%2C2%2C5%2C7%2C8%2C6%2C0%3E) and the goal state ![equation](https://latex.codecogs.com/gif.latex?%28%281%2C2%2C3%29%2C%284%2C5%2C6%29%2C%287%2C8%2CE%29%29), is represented as
![equation](https://latex.codecogs.com/gif.latex?%3C1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C0%2C8%3E).

Algorithm
----------

The steps followed by the algorithm can be stated as follows:
```

1. Initialize start state and goal state.
2. Initialize open list which contains nodes which are considered for expansion at every iteration, to null.
3. Initialize closed list which contains already expanded states to null.
4. Push the start state into the open list.
5. Pop the best element from the open list using the evaluation function 
   f(n)=g(n)+h(n) and set it as the current state. Best state element is the state with the minimum evaluation 
   function value.
6. If the current state is the goal state then return success and print the path from start state to goal state.
7. Generate successor states for the current states and push only those states into the open list which are not 
   present in the closed list.
8. Push the current element into the closed list.
9. Go to step 5 if the open list is not empty, else return failure.
.
  
```
Infeasible puzzles
--------------------
An infeasible puzzle deficiency is calculated by looking at the number of inversions in the start state as compared to 
the goal state. A given puzzle configuration is infeasible if the number of inversions 
are odd (http://www.geeksforgeeks.org/check-instance-8-puzzle-solvable/).

Known deficiencies
--------------------
The given heuristic of number of misplaced tiles works fine for easy board configurations. However, in case of complex configurations,
where large number of moves are involved to reach the goal state from the initial state, the heuristic does not perform well and hence
the search takes a long time to produce the output. This happens because the given heuristic is inefficient in capturing the progress 
of the search.

  
How to run
-----------------
Edit and save the file to enter start and goal states in the format mentioned later. Run the file using the
command **"clisp 8_puzzle.lisp"** from the terminal.


Output
--------

The output shows the sequence of states expanded to reach the goal state from the initial state. Additionally,
loop count and open list length are shown in every iteration for debugging purposes.





