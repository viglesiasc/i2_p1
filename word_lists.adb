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
end Word_Lists;
