with Ada.Text_IO;
with Ada.Unchecked_Deallocation;



package body Word_Lists is

	procedure Free is new
			  Ada.Unchecked_Deallocation
			  (Cell, Word_List_Type);

	procedure Add_Word (List: in out Word_List_Type;
					Word: in ASU.Unbounded_String) is

	P_Aux: Word_List_Type;
	P_Aux_New_Cell: Word_List_Type;
	Found: Boolean;

	begin
		Found := False;
		if List = Null then
			List := new Cell'(Word, 1, Null);
			P_Aux := List;
			P_Aux_New_Cell := List;
			Ada.Text_IO.Put_Line("crea primera celda");
			Ada.Text_IO.Put_Line(ASU.To_String(Word));
			Ada.Text_IO.Put_Line(ASU.To_String(P_Aux.Word));
		else
			while not Found loop
				Ada.Text_IO.Put_Line("???");

				if Word = P_Aux.Word then
					P_Aux.Count := P_Aux.Count + 1;
					Ada.Text_IO.Put_Line("suma contador");
					Found := True;
				else
					if P_Aux.Next = Null then
						Ada.Text_IO.Put_Line("no esta, crea nueva celda");
						P_Aux_New_Cell := New Cell'(Word, 1, Null);
						P_Aux.Next := P_Aux_New_Cell;
						P_Aux := Null;	--P_Aux := Null;
					else
						P_Aux := P_Aux.Next;
					end if;
				end if;
			end loop;
		end if;
	end Add_Word;
end Word_Lists;
