-- This is the generic specification for a dynamic queue abstract data type.

generic

	Size: Positive;    
    -- Size is included so that the array and dynamic implementations 
    --      have the same specification.  
    -- Size can be ignored in the dynamic implementation.

	type ItemType is private;

package QueuePkg is

	type Queue is limited private;

	Queue_Empty, Queue_Full: exception;

	function  isEmpty(Q: Queue) return Boolean;

	-- queue will never be full in this implementation
	function  isFull(Q: Queue) return Boolean;

	function  front(Q: Queue) return ItemType;

	procedure enqueue (Item: ItemType; Q: in out Queue);
	procedure dequeue (Q: in out Queue);

private

	type QueueNode;

	type QueueNodePointer is access QueueNode;

	type QueueNode is record
		Data: ItemType;
		Next: QueueNodePointer;
	end record;

	type Queue is record
		Front: QueueNodePointer := NULL;
		Back: QueueNodePointer := NULL;
	end record;

end QueuePkg;