use work.tbu_text_out_pkg.all;

-- Routines to help write testbenches at a higher level of abstraction (BDD)
package tbu_bdd_pkg is
    procedure describe(function_name: string);
    procedure should(msg: string; expr: boolean);
    procedure done;

end;

package body tbu_bdd_pkg is
    procedure describe(function_name: string) is begin
        put("Function " & function_name & " should:");
    end;

    procedure should(msg: string; expr: boolean) is begin
        assert expr report "error in test case '" & msg & "'" severity failure;
        put("- " & msg);
    end;

    procedure done is begin
        wait;
    end;
end;
