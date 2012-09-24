-- This is the generic specification for a dynamic stack abstract data type.

generic
  Size : Positive;
    -- Size is included so that the array and dynamic implementations will have 
    -- the same specification.  
    -- Size can be ignored in the dynamic implementation.

	type ItemType is private;

package StackPkg is

	type Stack is limited private;

	Stack_Empty, Stack_Full: exception;

	function isEmpty(S: Stack) return Boolean;
	function isFull(S: Stack) return Boolean;

	procedure push(Item: ItemType; S : in out Stack);
	procedure pop(S : in out Stack);

	function top(S: Stack) return ItemType;

private
	type StackNode;

	type Stack is access StackNode;

	type StackNode is record
		Item: ItemType;
		Next: Stack;
	end record;

end StackPkg;