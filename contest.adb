-- Name: Sarah Heredia
-- Date: December 6, 2011
-- Course: ITEC 320 Procedural Analysis and Design

-- Purpose: This program simulates a double elimination
--					tournament. 
--					INPUT:
--					The program will take inputs of a 
--					players name and skill level on one line, 
--					Skill number must start in column 21.
--					EXAMPLE: 
--						PlayerA             1
--						PlayerB             2
--						PlayerC             3
--						PlayerD             4
--					Players stand in lines until it is time for a match. 
--					Three lines are needed for different types of players: 
--						- those with no losses, 
--						- those with one loss, 
--						- and those with 2 losses (ie those who have been eliminated). 
--					The players form the line of no losses as they arrive at the 
--					contest (ie the order of this line will initially be the same 
--					as the order of the input data). When match time comes, the 
--					first two players in the appropriate line get out of line and 
--					play a match. The winner goes to the back of the same line, 
--					and the loser goes to the back of the line containing players 
--					with the appropriate number of losses. Players play in order.
--					The Winner of each match is determined by the following hierachy:
--						1: Highest Skill Level
--						2: Most Wins
--						3: Least Loses
--						4: Earliest Arrival into Contest
--					OUTPUT:
--					In the reverse elimination order on one line: 
--						- Player Name, Arrival Number, Skill Level, Wins, Losses

with Ada.Text_io; use Ada.Text_io;
with Ada.Integer_Text_io; use Ada.Integer_Text_io;
with Ada.Characters.Handling; use Ada.Characters.Handling;

-- Make the generic stack packages available
with queuepkg2;
with stackpkg2;   

procedure contest is

	-- Constants
	MAX_LENGTH_OF_NAME: constant Natural	:= 	20;
	
	-- Records
	-- A name has
	type aName is record
		Name: String (1 .. MAX_LENGTH_OF_NAME);
		Len: 	Natural;
	end record;
	
	-- A player has
	type Player is record
		Player_Name: 	aName; 
		Arrival_Num:	Natural;
		Skill_Level: 	Natural;
		Num_Loses: 		Natural := 0;
		Num_Wins: 		Natural := 0;
	end record;
	
	-- create stack and queue packages
	package playerQueuePkg is new queuepkg2(1000, Player);
	package playerStackPkg is new stackpkg2(1000, Player);
	
	-- Provide simplified access to package members
	use playerQueuePkg;
	use playerStackPkg;
	
	-- Variables
	zeroLossQueue: 		playerQueuePkg.Queue;
	oneLossQueue: 		playerQueuePkg.Queue;
	eliminatedStack: 	playerStackPkg.Stack;
	
	-- Procedures and Functions
	-- Gets length of play name
	procedure Get_Name(P: in out Player)  is
		C: 		Character;
		EOL: 	Boolean;
		Str: 	String (1 .. MAX_LENGTH_OF_NAME);
		i: 		Natural := 1;
	begin
		loop	
			Look_Ahead(C, EOL);
			exit when not Is_Letter(C);
			get(C);
			Str(i) := C;
			i := i + 1;
		end loop;
		P.Player_Name.Name 	:= str;
		P.Player_Name.Len 	:= i-1;
	end Get_Name;
	
	-- Gets a player from standard input
	procedure Get_Player (P: out Player) is
	begin
		Get_Name(P);
		Get(P.Skill_Level);
	end;	
	
	-- Prints out a player and thier statistics
	procedure Put_Player (P: Player) is
	begin
		Put(P.Player_Name.Name(1 .. P.Player_Name.Len)); Set_Col(21);
		Put(" "); Put(P.Arrival_Num, 3); 	Set_Col(29);
		Put(" "); Put(P.Skill_Level, 3); 	Set_Col(36);
		Put(" "); Put(P.Num_Wins, 3); 		Set_Col(44);
		Put(" "); Put(P.Num_Loses, 3);
		New_Line;
	end Put_Player;
	
	-- Updates Player statistics after a match
	procedure Update_Player_Stats
		(Winner: in out Player; Loser: in out Player) is
	begin
		Winner.Num_Wins := Winner.Num_Wins + 1;
		Loser.Num_Loses := Loser.Num_Loses + 1;
	end Update_Player_Stats;
	
	-- Determines winner of a match
	procedure Play_Match(p1: in out Player; p2: in out Player) is
	begin
		-- Highest Skill Level
		if p1.Skill_Level /= p2.Skill_Level then
			if p1.Skill_Level > p2.Skill_Level then
				Update_Player_Stats(p1, p2);
			else
				Update_Player_Stats(p2, p1);
			end if;
		-- Most Wins
		elsif p1.Num_Wins /= p2.Num_Wins then
			if p1.Num_Wins > p2.Num_Wins then
				Update_Player_Stats(p1, p2);
			else
				Update_Player_Stats(p2, p1);
			end if;
		-- Fewest Loses
		elsif p1.Num_Loses /= p2.Num_Loses then
			if p1.Num_Loses < p2.Num_Loses then
				Update_Player_Stats(p1, p2);
			else
				Update_Player_Stats(p2, p1);
			end if;
		-- Earliest Arrival
		else
			if p1.Arrival_Num < p2.Arrival_Num then
				Update_Player_Stats(p1, p2);
			else
				Update_Player_Stats(p2, p1);
			end if;
		end if;
		-- update stats
	end Play_Match;
	
	-- Places player in appropriate stack or queue based
	-- on number of loses
	procedure Place_Player(P: Player) is
	begin
		if P.Num_Loses = 0 then
			Enqueue(P, ZeroLossQueue);
		elsif P.Num_Loses = 1 then
			Enqueue(P, OneLossQueue);
		else -- Eliminated
			Push(P, EliminatedStack);
		end if;
	end Place_Player;
	
	-- Prints out heading above player names
	procedure Put_Heading is
	begin
		Set_Col(21); 		Put("Arrival");
		Set_Col(30); 		Put("Skill");
		New_Line;
		Put("Name"); 		Set_Col(21);
		Put("Number"); 	Set_Col(30);
		Put("Level"); 	Set_Col(38);
		Put("Wins"); 		Set_Col(45);
		Put("Loses");
		New_Line;
	end Put_Heading;
	
	-- main routine variables
	Count: 			Natural := 0;
	P, P1, P2: 	Player;
begin -- begin main routine
	-- Get all Players and put them in zeroLossPlayerQueue
	while not End_Of_File loop
		Count := Count + 1;
		Get_Player(P);
		P.Arrival_Num := Count;
		Enqueue(P, zeroLossQueue);
		Skip_Line;
	end loop;
	
	-- Make sure there are at least 2 players
	if count < 2 then
		Put_Line("Need at least two Players!");
	else
		-- Play all rounds with players that have no losses
		-- until only one player remains
		loop
			P1 := Front(ZeroLossQueue);
			Dequeue(ZeroLossQueue);
			if not isEmpty(ZeroLossQueue) then
				P2 := Front(ZeroLossQueue);
				Dequeue(ZeroLossQueue);
				Play_Match(P1, P2);
				Place_Player(P1);
				Place_Player(P2);
			-- Finalist has been determined
			-- No one left to play in this queue
			else
				Enqueue(P1, ZeroLossQueue);
				exit;
			end if;
		end loop;
		
		-- Play all rounds with players that have one loss
		-- until only one player remains
		while not isEmpty(OneLossQueue) loop
			P1 := Front(OneLossQueue);
			Dequeue(OneLossQueue);
			if not isEmpty(OneLossQueue) then
				P2 := Front(OneLossQueue);
				Dequeue(OneLossQueue);
				Play_Match(P1, P2);
				Place_Player(P1);
				Place_Player(P2);
			-- Finalist has been determined
			-- No one left to play in this queue
			else
				Enqueue(P1, OneLossQueue);
				exit;
			end if;
		end loop;
		
		-- Play Final Match
		-- Round 1 will always have one player in ZeroLossQueue
		-- and one player in OneLossQueue
		P1 := Front(ZeroLossQueue);
		Dequeue(ZeroLossQueue);
		P2 := Front(OneLossQueue);
		Dequeue(OneLossQueue);
		Play_Match(P1, P2);
		Place_Player(P1);
		Place_Player(P2);
		
		-- Check if Round 2 is necessary
		-- Only necessary if P2 beat P1
		-- If P1 won, OneLossQueue will be empty
		if isEmpty(OneLossQueue) then
			Push(P1, EliminatedStack);
		-- If P2 won, ZeroLossQueue will be empty
		-- Play another match
		-- This match will determine winner
		elsif isEmpty(ZeroLossQueue) then
			P1 := Front(OneLossQueue);
			Dequeue(OneLossQueue);
			P2 := Front(OneLossQueue);
			Dequeue(OneLossQueue);
			-- Play match
			Play_Match(P1, P2);
			Place_Player(P1);
			Place_Player(P2);
			
			-- Get Winner
			P1 := Front(OneLossQueue);
			Dequeue(OneLossQueue);
			Push(P1, EliminatedStack);
		end if;
		New_Line;
		Put_Heading;
		while not isEmpty(EliminatedStack) loop
			P := Top(EliminatedStack);
			Pop(EliminatedStack);
			Put_Player(P);
		end loop;
	end if;
end contest;



