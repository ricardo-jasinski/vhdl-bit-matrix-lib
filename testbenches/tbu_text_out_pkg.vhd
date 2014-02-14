library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- Routines to help output text at a higher level of abstraction.
package tbu_text_out_pkg is

    --type integer_vector is array (natural range <>) of integer;

    procedure put(text: string);
    procedure put(value: boolean);
    procedure put(value: real);
    procedure put(value: integer);
    procedure putv(vector: integer_vector);
    procedure putv(value: std_logic_vector);
    procedure putv(value: bit_vector);
    procedure putv(value: unsigned);
    procedure print(text: string; newline: boolean := true);

end;

package body tbu_text_out_pkg is

    procedure put(text: string) is
        variable s: line;
    begin
        write(s, text);
        writeline(output,s);
    end;

    -- Declare a shared line to allow incremental text output to the same line
    shared variable current_line: line;

    -- Incrementally output text to the same line. To force a line break, call
    -- with newline = true.
    procedure print(text: string; newline: boolean := true) is
    begin
        write(current_line, text);
        if (newline) then
            writeline(output, current_line);
        end if;
    end;

    procedure put(value: boolean) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

    procedure put(value: real) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

    procedure put(value: integer) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

    procedure putv(vector: integer_vector) is begin
        -- synthesis translate_off
        for i in vector'range loop
            print(to_string(vector(i)) & " ", newline => false);
        end loop;
        print("");
        -- synthesis translate_on
    end;

    procedure putv(value: std_logic_vector) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

    procedure putv(value: bit_vector) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

    procedure putv(value: unsigned) is begin
        -- synthesis translate_off
        put(to_string(value));
        -- synthesis translate_on
    end;

end;
