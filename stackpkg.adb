-- Name: Sarah Heredia
-- Date: December 6, 2011
-- Course: ITEC 320 Procedural Analysis and Design
--
-- Purpose: Generic implementation of a stack

with Ada.Text_IO; 	use Ada.Text_IO;

package body stackpkg is

	-- Returns true if the stack is empty, false otherwise
	function isEmpty(S: Stack) return Boolean is
	begin
		return s = null;
	end isEmpty;
		
	-- stack is dynamically sized, thus will always
	-- return false
	function isFull(S: Stack) return boolean is
	begin
		return false;
	end isFull;
	
	procedure push(Item: ItemType; S : in out Stack) is
		New_Node: Stack := new StackNode;
	begin
		New_Node.Item := Item;
		New_Node.Next := S;
		S := New_Node;
		S := New_Node;
	end push;
	
	procedure pop(S : in out Stack) is
	begin
		if isEmpty(S) then
			Put_Line("Stack is Empty");
		elsif S.Next = null then
			S := null;
		else
			S.Item := S.Next.Item;
			S.Next := S.Next.Next;
		end if;
	end pop;

	function top(S: Stack) return ItemType is
	begin
		return S.Item;
	end top;
end stackpkg;