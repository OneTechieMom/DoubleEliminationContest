-- Name: Sarah Heredia
-- Date: December 6, 2011
-- Course: ITEC 320 Procedural Analysis and Design
--
-- Purpose: Generic implementation of a queue

with Ada.Text_IO; 	use Ada.Text_IO;

package body queuepkg is	
	
	-- Returns true if the queue is empty, false otherwise
	function  isEmpty(Q: Queue) return Boolean is
	begin
		return Q.Front = NULL;
	end isEmpty;

	-- queue will never be full in this implementation
	function  isFull(Q: Queue) return Boolean is
	begin
		return false;
	end isFull;

	-- returns reference to item in node at front of queue
	-- returns reference to item at front of queue
	function  front(Q: Queue) return ItemType is
	begin	
		return Q.Front.Data;
	end front;

	-- puts a new node on back of queue
	procedure enqueue (Item: ItemType; Q: in out Queue) is
		New_Node: QueueNodePointer;
	begin
		New_Node := new QueueNode'(Item, NULL);
		if isEmpty(Q) then 						-- if empty
			Q.Front := New_Node;
		else
			Q.Back.Next := New_Node;
		end if;	
		Q.Back := New_Node;
	end enqueue;
		
	-- removes node from front of queue
	procedure dequeue (Q: in out Queue) is
		Remove_Node: QueueNodePointer;
	begin
		if isEmpty(Q) then						-- if empty
			Put_Line("Queue is Empty");
		else																				
			Remove_Node := Q.Front;
			Q.Front := Remove_Node.Next;
		end if;
	end dequeue;
	
end queuepkg;