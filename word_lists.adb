with Ada.Text_IO;
with Ada.Unchecked_Deallocation;



package body Word_Lists is

	procedure Free is new
			  Ada.Unchecked_Deallocation
			  (Cell, Word_List_Type);

	procedure Add_Word (List: in out Word_List_Type;
					Word: in ASU.Unbounded_String) is

	P_Aux: Word_List_Type;
	New_Cell: Word_List_Type:= List;
	Found: Boolean;


	begin
		Found := False;
		P_Aux := List;
		if List = Null then
			New_Cell := New Cell'(Word, 1, Null);
			List := New_Cell;
			--Ada.Text_IO.Put_Line("crea primera celda");
		else
			while not Found loop
				if ASU.To_String(P_Aux.Word) = ASU.To_String(Word) then
					P_Aux.Count := P_Aux.Count + 1;
					--Ada.Text_IO.Put_Line("suma contador");
					Found := True;
				else
					if P_Aux.Next = Null then
						--Ada.Text_IO.Put_Line("no esta, crea nueva celda");
						New_Cell := New Cell'(Word, 1, Null);
						P_Aux.Next := New_Cell;
						P_Aux := List;
						Found:= True;
					else
						--Ada.Text_IO.Put_Line("siguiente");
						P_Aux := P_Aux.Next;
					end if;
				end if;
			end loop;
		end if;
	end Add_Word;


	procedure Print_All (List: in Word_List_Type) is
			Finish: Boolean:= False;
			P_Aux: Word_Lists.Word_List_Type:= List;
	begin
		if List = Null then
			Ada.Text_IO.Put_Line("No words");
		else
			P_Aux:= List;
			while not Finish loop
				if P_Aux /= Null then
					Ada.Text_IO.Put("|");
					Ada.Text_IO.Put(ASU.To_String(P_Aux.Word));
					Ada.Text_IO.Put("|");
					Ada.Text_IO.Put(" - ");
					Ada.Text_IO.Put_Line(Integer'Image(P_Aux.Count));
					P_Aux:= P_Aux.Next;
				else
					Finish:= True;
				end if;
			end loop;
		end if;
	end Print_All;


	procedure Max_Word (List: in Word_List_Type; Word: out ASU.Unbounded_String;
										Count: out Natural) is

		--Count:= 0;
		P_Aux: Word_List_Type:= List;

	begin

		if List = Null then
			raise Word_List_Error;
		else
			Count:= P_Aux.Count;
			Word:= P_Aux.Word;
			P_Aux:= P_Aux.Next;
			while P_Aux /= Null loop
				if P_Aux.Count > Count then
					Count := P_Aux.Count;
					Word:= P_Aux.Word;
				else
					P_Aux:= P_Aux.Next;
				end if;
			end loop;
			Ada.Text_IO.Put("The most frequent word: |");
			Ada.Text_IO.Put(ASU.To_String(Word));
			Ada.Text_IO.Put("| - ");
			Ada.Text_IO.Put_Line(Integer'Image(Count));
		end if;
	end Max_Word;


	procedure Search_Word (List: in Word_List_Type; Word: in ASU.Unbounded_String;
											Count: out Natural) is
		Finish: Boolean:= False;
		P_Aux: Word_List_Type;

	begin
		Count:= 0;
		if List /= Null then
			P_Aux:= List;
			while (not Finish) and P_Aux /= Null loop
				if ASU.To_String(P_Aux.Word) = ASU.To_String(Word) then
					Count:= P_Aux.Count;
					Finish := True;
				else
					P_Aux:= P_Aux.Next;
				end if;
			end loop;
		else
			Count:= 0;
		end if;
	end Search_Word;


	procedure Delete_Word (List: in out Word_List_Type;	Word: in ASU.Unbounded_String) is
		Count: Natural;
		P_Aux: Word_List_Type;
		P_Aux2: Word_List_Type;
		Found: Boolean;
	begin
		Found:= False;
		Search_Word(List, Word, Count);
		P_Aux:= List;
		If Count = 0 then
			Ada.Text_IO.Put("Word_List_Error");
		else
			if ASU.To_String(List.Word) = ASU.To_String(Word)  then
				List:= List.Next;
			else
				while (not Found) and P_Aux /= Null loop
					if ASU.To_String(P_Aux.Next.Word) = ASU.To_String(Word) then
						P_Aux2:= P_Aux.Next;
						P_Aux.Next:= P_Aux2.Next;
						Found:= True;
					else
						P_Aux:= P_Aux.Next;
					end if;
				end loop;
			end if;
		end if;
	end Delete_Word;
end Word_Lists;
