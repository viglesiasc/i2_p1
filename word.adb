with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;
with Word_Lists;

procedure Word is
	package ACL renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;

	Usage_Error: exception;
	File_Name: ASU.Unbounded_String;
	Show_Options: Boolean;
	Finish_Loop: Boolean;
	subtype Options_Range is Integer range 1..5;
	Option_Number: Options_Range;
	My_List: Word_Lists.Word_List_Type;




		procedure Find_File(File_Name: out ASU.Unbounded_String; Show_Options: out Boolean) is
		begin
			Show_Options:= False;
			if ACL.Argument_Count /= 1 and ACL.Argument_Count /= 2  then
				raise Usage_Error;
			end if;
			if ACL.Argument_Count = 1 then
				File_Name := ASU.To_Unbounded_String(ACL.Argument(1));
			else
				File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
				if ASU.To_String(ASU.To_Unbounded_String(ACL.Argument(1))) = "-i" then
					Show_Options:= True;
				else
					raise Usage_Error;
				end if;
			end if;
		end Find_File;

		procedure Separate_Words(Line: in out ASU.Unbounded_String) is
			Space_Position: Natural;
			Word: ASU.Unbounded_String;
			End_Line: Boolean := False;
			--List: Word_Lists.Word_List_Type;


		begin
			while not End_Line loop
				if ASU.Length(Line) = 0 then
					End_Line:= True;
				else
					--  Space_Position = posición de la cadena donde se encuentra el espacio
					Space_Position := ASU.Index(Line, " ");
					case Space_Position is
						when 1 =>
							End_Line:= False;
							Line := ASU.Tail(Line, ASU.Length(Line) - 1);
						when 0 =>
							Word:= Line;
							-- Meto palabra en lista dinamica
							Word_Lists.Add_Word(My_List, Word);
							End_Line:= True;
						when others =>
							--  Word = principio de la cadena hasta el espacio
							Word := ASU.Head(Line, Space_Position - 1);
							-- Meto palabra en lista dinamica
							Word_Lists.Add_Word(My_List, Word);
							-- Line = el final de la cadena final desde el Space_Position
							Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
					end case;

				end if;
			end loop;

		end Separate_Words;


		procedure Separate_Lines(File_Name: out ASU.Unbounded_String) is
			Line: ASU.Unbounded_String;
			File: Ada.Text_IO.File_Type;
			Finish: Boolean;
			begin
				Find_File(File_Name, Show_Options);
				Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));
				Finish := False;
				while not Finish loop
				begin
					Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
					-- Ada.Text_IO.Put_Line(ASU.To_String(Line));
					Separate_Words(Line);
				exception
					when Ada.IO_Exceptions.End_Error =>
							Finish := True;
				end;
				end loop;
				Ada.Text_IO.Close(File);
			end Separate_Lines;



		procedure Print_Options (Option_Number: out Integer) is
			begin
				Ada.Text_IO.Put_Line("");
				Ada.Text_IO.Put_Line("Options");
				Ada.Text_IO.Put_Line("1 Add word");
				Ada.Text_IO.Put_Line("2 delete word");
				Ada.Text_IO.Put_Line("3 Search Word");
				Ada.Text_IO.Put_Line("4 Show all words");
				Ada.Text_IO.Put_Line("5 Quit");
				Ada.Text_IO.Put_Line("");
				Ada.Text_IO.Put("Your option? ");
				Option_Number := Integer'Value(Ada.Text_IO.Get_Line);
			end Print_Options;

		procedure Quit is
			begin
				Ada.Text_IO.Put("The most frequent word: |");
				Ada.Text_IO.Put("____________");
				Ada.Text_IO.Put("| - ");
				Ada.Text_IO.Put_Line("3.14");
			end Quit;

begin
		Find_File(File_Name, Show_Options);
		--Separate_Lines(File_Name);
		if Show_Options = True then
			Finish_Loop:= False;
			while not Finish_Loop loop
				Print_Options(Option_Number);
				case Option_Number is
					when 1 =>
						Ada.Text_IO.Put_Line("Has elegido la opcion 1");
					when 2 =>
						Ada.Text_IO.Put_Line("Has elegido la opcion 2");
					when 3 =>
						Ada.Text_IO.Put_Line("Has elegido la opcion 3");
					when 4 =>
						Ada.Text_IO.Put_Line(" ");
						Separate_Lines(File_Name);
						Word_Lists.Print_All(My_List);
					when 5 =>
						Separate_Lines(File_Name);
						Quit;
						Finish_Loop:= True;
				end case;
				Ada.Text_IO.Put(" ");
			end loop;
		else
			Separate_Lines(File_Name);
		end if;


exception
	when Usage_Error =>
		Ada.Text_IO.Put_Line("usage: " & "words " & "[-i] " & "<filename>");


end Word;
