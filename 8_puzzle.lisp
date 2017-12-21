;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 											      ;;;											  
;;; Title    :   8 puzzle solver using a* algorithm.                             	      ;;;
;;; Problem  :   Implement the A* search for searching trees (in Lisp). Do not 		      ;;;
;;;          :   use Russell’s code or other code from the web. Implement a 		      ;;;
;;;          :   counter that counts the number of nodes expanded and prints this	      ;;;
;;;          :   number at the end of the search. Use your code to solve the 		      ;;;
;;;          :   8-puzzle problem with heuristic being the number of misplaced 		      ;;;
;;;          :   tiles and start state ((E, 1, 3),(4, 2, 5),(7, 8,6)). The goal 	      ;;;
;;;          :   state is: ((1, 2, 3),(4, 5, 6),(7, 8, E)). Print the number of 	      ;;;
;;;          :   nodes expanded. You only need to show the states generated 		      ;;;
;;;          :   during the search process. Your code should detect infeasible 		      ;;;
;;;          :   puzzles.				  				      ;;;
;;; Date     :   Dec 03, 2017								      ;;;
;;; Author   :   Mahendra Maiti	                                                              ;;;
;;; email	:   maiti013@umn.edu							      ;;;
;;; Assignment:  Artificial Intelligence CSCI 5511 - Lisp Assignment			      ;;;
;;; Due Date :   Dec 07, 2017								      ;;;
;;;											      ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;; structure representing a state for a particular problem
(defstruct state
	node
	g_val
	h_val
	f_val
	parent
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;											      ;;
;; 	node::  (t1 t2 t3 t4 t5 t6 t7 t8 t9 pos_blank)  				      ;;	
;;		The 3X3 matrix is represented here as a single list of tile values            ;;			
;;		called 'node'. 							              ;;
;;		Additionally node containes the position of the blank tile at the end.        ;;	
;; 											      ;;
;;											      ;;	
;;											      ;;
;; 	pos_blank:: represents the position of the blank in the board represented as a list   ;;
;;											      ;;
;;	g_val:: represents the g-value at a particular state                                  ;;
;;											      ;;
;;	h_val:: represents the h-value at a particular state                                  ;;
;;											      ;;
;;	f_val:: represents the f-value at a particular state                                  ;;
;;											      ;;	
;;	parent:: represents the parent of a particular state                                  ;;
;;											      ;;											  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;declare the goal nodes and start nodes as global variables

(defvar *goal_node* (list '1 '2 '3 '4 '5 '6 '7 '8 '0 '8))

(defvar *start_node* (list '0 '1 '3 '4 '2 '5 '7 '8 '6 '0))    ;;finds solution
;(defvar *start_node* (list '1 '2 '3 '4 '5 '0 '7 '8 '6 '5))   ;;finds solution
;(defvar *start_node* (list '1 '2 '0 '4 '5 '3 '7 '8 '6 '2))   ;;finds solution
;(defvar *start_node* (list '8 '1 '2 '0 '4 '3 '7 '6 '5 '3))   ;;infeasible puzzle
;(defvar *start_node* (list '4 '5 '6 '0 '1 '2 '7 '8 '6 '3))   ;;infeasible puzzle
;(defvar *start_node* (list '4 '2 '5 '0 '1 '3 '7 '8 '6 '3))   ;;finds solution






	
(defun calc_h_val (curr_node) 
;;	function which calculates the value of the heuristic function at the current node.
;;  Here the heuristic function is the number of misplaced tiles.
	(if(eq curr_node NIL)
		(return-from calc_h_val 9999)
	)

	(setf inplaced_tiles 0)
	;the loop below calculates the number of correctly positioned tiles
	(dotimes(counter 9)
		(if(eq (nth counter curr_node) (nth counter *goal_node*))
			(setf inplaced_tiles (+ inplaced_tiles 1))()
		)
		collect inplaced_tiles
	)

	(return-from calc_h_val (- 9 inplaced_tiles))
)

(defun set_h_val(temp_node)
;;	helper function for the function calc_h_val
	(setf h (calc_h_val temp_node))
)

(defun init_state(temp_node)
;;	function that is used to initialise the values of a newly generated state
	(setq new_state (make-state :node temp_node
		:g_val 0
		:h_val ((lambda (temp_node) (setf h (set_h_val temp_node))) temp_node)
		:f_val 9999
		:parent NIL ))

	(return-from init_state new_state)
)

(defun swap_list(given_list new_blank_pos old_blank_pos)
;;	function that generates a new list with blank tile moved to the specified position

	(setf copied_list (copy-list given_list))
	(rotatef (nth new_blank_pos copied_list) (nth old_blank_pos copied_list))
	(fill copied_list new_blank_pos :start 9 :end 10) ;update the blank posiion in the new list
	(return-from swap_list copied_list)

)


(defun generate_successors(temp_state)
;;	function that generates successor states for a given temporary state
	(setf curr_node (state-node temp_state))
	(setf pos_blank (nth 9 curr_node)) ;get the index of the blank tile
	(setf move_up_index (- pos_blank 3))
	(setf move_down_index (+ pos_blank 3))
	(setf move_left_index (- pos_blank 1))
	(setf move_right_index (+ pos_blank 1))
	(setf up_child NIL)
	(setf down_child NIL)
	(setf left_child NIL)
	(setf right_child NIL)
	(setf parent_g_val (state-g_val temp_state))
	(if(>= move_up_index 0)
		(progn 
			(setf up_child (swap_list curr_node move_up_index pos_blank)) 
			;modified list representing tiles in the new position
			(setf up_state (init_state up_child))
			(setf (state-g_val up_state) (+ 1 parent_g_val)) 
			;modify g_hat value of child
			(setf (state-f_val up_state) (+ (state-g_val up_state) (state-h_val up_state)))
			;update f_har value of child
			(setf (state-parent up_state) temp_state)

		)
		(progn
			(setf up_child NIL) 
			;modified list representing tiles in the new position
			(setf up_state (init_state up_child))
			(setf (state-g_val up_state) 9999) 
			;modify g_hat value of child
			(setf (state-f_val up_state) 9999) 
			;update f_har value of child
			(setf (state-parent up_state) NIL)
		)
		

	)
	(if(<= move_down_index 8)
		(progn
			(setf down_child (swap_list curr_node move_down_index pos_blank))
			(setf down_state (init_state down_child))
			(setf (state-g_val down_state) (+ 1 parent_g_val)) 
			;modify g_hat value of child
			(setf (state-f_val down_state) (+ (state-g_val down_state) 
					(state-h_val down_state))) 
			;update f_har value of child
			(setf (state-parent down_state) temp_state)
		)
		(progn
			(setf down_child NIL)
			(setf down_state (init_state down_child))
			(setf (state-g_val down_state) 9999) ;modify g_hat value of child
			(setf (state-f_val down_state) 9999) ;update f_har value of child
			(setf (state-parent down_state) NIL)
		)
		
	)
	(if(and (>= move_left_index 0)(/= (mod pos_blank 3) 0))
		(progn
			(setf left_child (swap_list curr_node move_left_index pos_blank))
			(setf left_state (init_state left_child))
			(setf (state-g_val left_state) (+ 1 parent_g_val)) 
			;modify g_hat value of child
			(setf (state-f_val left_state) (+ (state-g_val left_state) 
					(state-h_val left_state))) ;update f_har value of child
			(setf (state-parent left_state) temp_state)
		)
		(progn
			(setf left_child NIL)
			(setf left_state (init_state left_child))
			(setf (state-g_val left_state) 9999) ;modify g_hat value of child
			(setf (state-f_val left_state) 9999) ;update f_har value of child
			(setf (state-parent left_state) NIL)
		)
		
	)
	(if(and (<= move_right_index 8) (/= (mod (+ 1 pos_blank) 3) 0))
		(progn

			(setf right_child (swap_list curr_node move_right_index pos_blank))
			(setf right_state (init_state right_child))
			(setf (state-g_val right_state) (+ 1 parent_g_val)) 
			;modify g_hat value of child
			(setf (state-f_val right_state) (+ (state-g_val right_state) 
					(state-h_val right_state))) ;update f_har value of child
			(setf (state-parent right_state) temp_state)

		)
		(progn

			(setf right_child NIL)
			(setf right_state (init_state right_child))
			(setf (state-g_val right_state) 9999) ;modify g_hat value of child
			(setf (state-f_val right_state) 9999) ;update f_har value of child
			(setf (state-parent right_state) NIL)

		)
		
	)
	(setf list_of_sons (list up_state down_state left_state right_state))

)


(defun best_state (open_list) 
;; function that returns best state among list of open states

	(setf min_el (init_state (state-node (nth 0 open_list))))
	(setf (state-f_val min_el) 9999)
	(block list_loop
		(loop for s in open_list do
			(if(< (state-f_val s) (state-f_val min_el))
					(setf min_el (copy-state s)) () )
		)
		(return-from list_loop min_el)
	)
)


(defun equal_states(curr_state goal_node)
;; function to check whether node of current state matches with goal node
	(setf list1 (subseq (state-node curr_state) 0 9))
	(setf list2 (subseq goal_node 0 9))

	(dotimes(counter 9)
		(
			if(not(eq (nth counter list1)(nth counter list2)))
				(return-from equal_states NIL)
		)

	)

	(return-from equal_states T)
	
)

(defun print_board (node_list)
;; function that prints the board moves in an elegant manner
	(loop for x in node_list do
		(setf t_list (subseq x 0 (- (list-length x) 1)))
		(format t "~a ~a ~a ~%" (first x) (second x) (third x))
		(format t "~a ~a ~a ~%" (fourth x) (fifth x) (sixth x))
		(format t "~a ~a ~a ~%" (seventh x) (eighth x) (ninth x))
		(format t "~v@{~A~:*~}~%~%" 30 "-")
	)

)
(defun print_state(x)
;; function that prints the state into a suitable board like representation
		(format t "~a ~a ~a ~%" (first x) (second x) (third x))
		(format t "~a ~a ~a ~%" (fourth x) (fifth x) (sixth x))
		(format t "~a ~a ~a ~%" (seventh x) (eighth x) (ninth x))
		(format t "~v@{~A~:*~}~%~%" 30 "-")

)

(defun print_path(curr_state states_expanded)

;; function to print path between start state and goal state
	(format t "~%Search successful~%")
	(format t "~%Generated states are: ~% ~%")
	(setf node_list nil)
	(loop while(not(eq curr_state NIL)) do
		(progn
			
			(push (state-node curr_state) node_list)
			
			(setf curr_state (state-parent curr_state))
			
		)
		
	)
	(reverse  node_list)

	(print_board node_list)
	
	(format t "~%Number of moves: ~a ~%" (list-length node_list))
	(format t "~%~%Number of nodes expanded is ~a~%~%" states_expanded)
)

(defun search_duplicate(temp_state search_list)

	;returns the version of temp_state which is present in search_list if at all
	;two states will be equal if their node values are equal
	;search_list is a list of states

	(loop for s in search_list do
		(setf c_node (state-node s))
		(if(equal_states temp_state c_node)
			(return s)
		)

	)

)

(defun remove_element (el s_list)
;; function to remove the given element from the given list
	(setq m_list nil)
	(loop for states in s_list do
		(progn
			(if(not(equal (state-node states) (state-node el)))
				(
					push states m_list
				)
			)
			
		)
		collect m_list
	)
	(return-from remove_element m_list)
)



(defun is_feasible (start_node goal_node)
;; function to check whether goal state can be achieved from initial state
	(setf start_pair_list nil)
	(setf goal_pair_list nil)
	(dotimes(outer_counter 9)
		(progn
			(if(not(eq (nth outer_counter start_node) 0))
				(progn
					(setf inner_counter (+ 1 outer_counter))
					(loop while(<= inner_counter 8) do
						(progn
							
							(if(not(eq(nth inner_counter start_node) 0))
								(progn
									(push (list (nth outer_counter start_node) 
													(nth inner_counter start_node)) 
														start_pair_list)

								)
							)
							(setf inner_counter (+ 1 inner_counter))

						)
					)

				)
			)
		)
	)
	
	(dotimes(outer_counter 9)
		(progn
			(if(not(eq (nth outer_counter goal_node) 0))
				(progn
					(setf inner_counter (+ 1 outer_counter))
					(loop while(<= inner_counter 8) do
						(progn
							
							(if(not(eq(nth inner_counter goal_node) 0))
								(progn
									(push (list (nth outer_counter goal_node) 
													(nth inner_counter goal_node)) 
														goal_pair_list)

								)
							)
							(setf inner_counter (+ 1 inner_counter))

						)
					)

				)
			)
		)
	)
	(setf common 0)
	(loop for x in start_pair_list do

		(loop for y in goal_pair_list do
			(progn
				(if(and (eq (first x) (first y)) (eq (second x)(second y)) )
					(setf common (+ 1 common))
				)
			)
			
			
		)
	)
	(setf inversion_count 0)	
	
	(setf inversion_count (- (list-length start_pair_list) common))
	
	(if(eq (mod inversion_count 2) 0)(return-from is_feasible T)
						(return-from is_feasible NIL))
)


(defun A_STAR (start_state goal_node)
;;function that executes the a-star algorithm using helper functions
	(format t "~%Started Execution ~% ~%")
	(setf s_node (state-node start_state))
	(setf g_node goal_node)
	(format t "~%Start state: ~%")
	(print_state s_node)
	(format t "Goal state: ~%")
	(print_state goal_node) 

	(if(not(is_feasible (state-node start_state) goal_node))
		(progn
			;;detects infeasible puzzle
			(format t "~%Infeasible Puzzle!!~%")
			(return-from A_STAR "infeasible puzzle")
		)
		
	)

	(setf closed_list nil)
	(setf states_expanded 0)
	(setf counter 0)
	(if(null start_state)
		(progn
	;;returns failure if the open list is null at any point of time of execution
			(format t "~%Failure!!~%")
			(return-from A_STAR "Failure")
		)
		
	)
	(setf open_list (list start_state))
	(setf counter 0)

	(loop while (not(null open_list)) do
	(progn

		(setf counter (+ 1 counter))


		(setf current (best_state open_list))

		(with-open-file (stream "data.txt"  
		;;outputs data to a text file for debugging purposes
                     :direction :output
                     :if-exists :append
                     :if-does-not-exist :create)
		(format stream " ~a " counter)
		(format stream "state: ~a   f_val: ~a  g_val: ~a h_val: ~a ~%" 
						(state-node current) (state-f_val current)
											(state-g_val current) (state-h_val current))
 		)

		(incf states_expanded)

		(if(equal_states current goal_node) ;check whether current state is equal to goal state
			(progn
					
				(print_path current states_expanded)
				(return-from A_STAR 'success)
			)
			
		)
		
		(setf sons (generate_successors current)) ;generate all successor states of the current best node
		

		(loop for son in sons do
			(progn
				( if(state-node son)
					(progn
						(setf son_old_closed (search_duplicate son closed_list))
						
						;;the following conditions apply in case the graph search algorithm version
						;(cond  
							#|((and (null son_old_open ) (null son_old_closed))
								(push son open_list)

							)
							(
								(and (not(null son_old_open)) (< (state-f_val son) (state-f_val son_old_open)))
									(progn ;;if new sucessor is already in the open list
										(setf open_list (remove_element son_old_open open_list)) 
										(push son open_list)
									)
							)
							(
								(and (not(null son_old_closed)) (< (state-f_val son) (state-f_val son_old_closed)))
									(progn	 ;;if the new sucessor is already in the closed list
										(setf closed_list (remove_element son_old_closed closed_list))
										(push son open_list)
									)
							)|#
							#|(
								(and (not(null son_old_open)) (not(null son_old_closed)))
									(push son open_list)
							)
							|#
						;)
						(if(null son_old_closed)
								(push son open_list))
						
					)
				)
			)
		)
		(push current closed_list) 
		;add the current element in the closed list
		(setf open_list (remove_element current open_list))
		;remove the current element from the open list

	)

	)

	return "Failure"

)




(defun 8_puzzle_solver()
;; This function calls the a_star algorithm for solving the given 8-puzzle problem
(setf start_state (init_state *start_node*))
(A_STAR start_state *goal_node*)  ;;call to the a_star function
(format t "~v@{~A~:*~}~%~%" 70 "#")
)








