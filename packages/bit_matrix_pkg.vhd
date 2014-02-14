use std.textio.all;

-- Types and operations for working with boolean matrices. In a boolean matrix,
-- elements are of type bit, and operations are defined over the finite field
-- GF(2).
package bit_matrix_pkg is
    type bit_matrix is array (natural range <>, natural range <>) of bit;
    procedure inspect(matrix: bit_matrix; tag: string := "");
    function to_bit_matrix(input_matrix: bit_matrix) return bit_matrix;
    function bit_matrix_from_value(rows_count, cols_count: integer; value: bit) return bit_matrix;
    function zeroes(rows_count, cols_count: integer) return bit_matrix;
    function ones(rows_count, cols_count: integer) return bit_matrix;
    function null_bit_matrix(rows_count, cols_count: integer) return bit_matrix;
    function identity_bit_matrix(size: integer) return bit_matrix;
    function matrix_column(m: bit_matrix; c: integer) return bit_vector;
    function matrix_row(m: bit_matrix; r: integer) return bit_vector;
    function exchange_rows(m: bit_matrix; r1, r2: integer) return bit_matrix;
    function sub_matrix(m: bit_matrix; r1, c1, r2, c2: integer) return bit_matrix;
    function transpose(m: bit_matrix) return bit_matrix;
    function shift_left_matrix(matrix: bit_matrix; new_column: bit_vector) return bit_matrix;
    function shift_left(matrix: bit_matrix) return bit_matrix;
    function shift_left(matrix: bit_matrix; shift_amount: natural) return bit_matrix;
    function replace_matrix_column(input_matrix: bit_matrix; new_column: bit_vector; column_index: integer) return bit_matrix;
    function replace_element(row, col: integer; value: bit; matrix: bit_matrix) return bit_matrix;
    function height(matrix: bit_matrix) return integer;
    function width(matrix: bit_matrix) return integer;
    function columns_within_range(m: bit_matrix; c1, c2: integer) return bit_matrix;
    function leftmost_columns(matrix: bit_matrix; columns_count: integer) return bit_matrix;
    function rightmost_columns(matrix: bit_matrix; columns_count: integer) return bit_matrix;
    function "*"(vector: bit_vector; matrix: bit_matrix) return bit_vector;
    function "*"(m1: bit_matrix; m2: bit_matrix) return bit_matrix;
    -- maximum string lenght for a label/matrix name/identifier
    constant LABEL_SIZE_MAX: integer := 80;
end package;

package body bit_matrix_pkg is
    function exchange_rows(m: bit_matrix; r1, r2: integer) return bit_matrix is
        constant ROWS_COUNT: integer := m'length(1);
        constant COLS_COUNT: integer := m'length(2);
        variable retMat: bit_matrix(1 to ROWS_COUNT, 1 to COLS_COUNT);
    begin
        retMat := m;
        for i in 1 to ROWS_COUNT loop
            for j in 1 to COLS_COUNT loop
                if i = r1 then
                    retMat(i, j) := m(r2, j);
                elsif i = r2 then
                    retMat(i, j) := m(r1, j);
                end if;
            end loop;
        end loop;

        return retMat;
    end function exchange_rows;

    -- extrai uma coluna de uma matriz, retornando-a na forma de um vetor
    function matrix_column(m: bit_matrix; c: integer) return bit_vector is
        variable retVect: bit_vector(m'range);
    begin
        for i in retVect'range loop
            retVect(i) := m(i, c);
        end loop;
        return retVect;
    end function matrix_column;

    -- extrai uma linha de uma matriz, retornando-a na forma de um vetor
    function matrix_row(m: bit_matrix; r: integer) return bit_vector is
        variable retVect: bit_vector(m'range(2));
    begin
        for j in retVect'range loop
            retVect(j) := m(r, j);
        end loop;
        return retVect;
    end function matrix_row;

    function bit_matrix_from_value(rows_count, cols_count: integer; value: bit) return bit_matrix is
        variable matrix: bit_matrix(1 to rows_count, 1 to cols_count);
    begin
        for i in 1 to rows_count loop
            for j in 1 to cols_count loop
                matrix(i, j)  := value;
            end loop;
        end loop;
        return matrix;
    end function;

    function zeroes(rows_count, cols_count: integer) return bit_matrix is
    begin
        return bit_matrix_from_value(rows_count, cols_count, '0');
    end function;

    function ones(rows_count, cols_count: integer) return bit_matrix is
    begin
        return bit_matrix_from_value(rows_count, cols_count, '1');
    end function;

    -- retorna uma matriz com as dimensões especificadas e todos
    -- os elementos iguais a '0'
    function null_bit_matrix(rows_count, cols_count: integer) return bit_matrix is
    begin
        return zeroes(rows_count, cols_count);
    end function;

    -- Gera uma matrix identidade.
    function identity_bit_matrix(size: integer) return bit_matrix is
        variable matrix: bit_matrix(1 to size, 1 to size);
    begin
        for i in 1 to size loop
            for j in 1 to size loop
                if i = j then
                    matrix(i, j) := '1';
                else
                    matrix(i, j) := '0';
                end if;
            end loop;
        end loop;
        return matrix;
    end function;

    -- retorna uma sub-matriz da matriz especificada
    function sub_matrix(m: bit_matrix; r1, c1, r2, c2: integer) return bit_matrix is
        constant rowsCount: integer := r2 - r1 + 1;
        constant colsCount: integer := c2 - c1 + 1;
        variable retMat: bit_matrix(1 to rowsCount, 1 to colsCount);
    begin
        for i in 1 to rowsCount loop
            for j in 1 to colsCount loop
                retMat(i, j) := m(r1 + i - 1, c1 + j - 1);
            end loop;
        end loop;
        return retMat;
    end function sub_matrix;

    -- retorna uma sub-matriz da matriz especificada
    function columns_within_range(m: bit_matrix; c1, c2: integer) return bit_matrix is
        constant rowsCount: integer := m'length(1);
        constant colsCount: integer := c2 - c1 + 1;
        variable retMat: bit_matrix(1 to rowsCount, 1 to colsCount);
    begin
        for i in 1 to rowsCount loop
            for j in c1 to c2 loop
                retMat(i, j - c1 + 1) := m(i, j);
            end loop;
        end loop;
        return retMat;
    end function columns_within_range;

    function leftmost_columns(matrix: bit_matrix; columns_count: integer) return bit_matrix is
    begin
        return columns_within_range(matrix, 1, columns_count);
    end function;

    function rightmost_columns(matrix: bit_matrix; columns_count: integer) return bit_matrix is
        constant colsCount: integer := matrix'length(2);
    begin
        return columns_within_range(matrix, colsCount - columns_count + 1, colsCount);
    end function;

    function transpose(m: bit_matrix) return bit_matrix is
        variable retMat: bit_matrix(m'range(2), m'range(1));
    begin
        for i in m'range(1) loop
            for j in m'range(2) loop
                retMat(j, i) := m(i, j);
            end loop;
        end loop;

        return retMat;
    end;

    function to_bit_matrix(input_matrix: bit_matrix) return bit_matrix is
        variable output_matrix: bit_matrix(1 to height(input_matrix), 1 to width(input_matrix));
        variable x_offset: integer := 1 - input_matrix'left(1);
        variable y_offset: integer := 1 - input_matrix'left(2);
    begin
        for i in output_matrix'range(1) loop
            for j in output_matrix'range(2) loop
                output_matrix(i, j) := input_matrix(i - y_offset, j - x_offset);
            end loop;
        end loop;

        return output_matrix;
    end;

    function replace_element(row, col: integer; value: bit; matrix: bit_matrix) return bit_matrix is
        variable output: bit_matrix(matrix'range(1), matrix'range(2));
    begin
        for i in matrix'range(1) loop
            for j in matrix'range(2) loop
                if i = row and j = col then
                    output(i, j) := value;
                else
                    output(i, j) := matrix(i, j);
                end if;
            end loop;
        end loop;

        return output;
    end;

    function replace_matrix_column(input_matrix: bit_matrix; new_column: bit_vector; column_index: integer) return bit_matrix is
        variable output: bit_matrix(input_matrix'range(1), input_matrix'range(2));
    begin
        for i in input_matrix'range(1) loop
            for j in input_matrix'range(2) loop
                if j = column_index then
                    output(i, j) := new_column(i);
                else
                    output(i, j) := input_matrix(i, j);
                end if;
            end loop;
        end loop;

        return output;
    end;

    function "*"(vector: bit_vector; matrix: bit_matrix) return bit_vector is
        variable result: bit_vector(matrix'range(2));
    begin
        for j in result'range loop
            --result(j) := elements_xor(
            result(j) := xor(
                    -- AND bit-a-bit entre o vetor 'v' e a coluna 'j' da matriz
                    vector and matrix_column(matrix, j)
                );
        end loop;

        return result;
    end function;

    --------------------------------------------------------------------------------
    ---[ http://www.zweigmedia.com/RealWorld/tutorialsf1/frames3_2.html ]-----------
    --------------------------------------------------------------------------------
    -- The Product of Two Matrices: General Case
    -- In general, we can take the product AB only if the number of columns of A
    -- equals the number of rows of B (so that we can multiply the rows of A by the
    -- columns of B as above).
    --
    -- Note: The product AB has as many rows as A and as many columns as B.
    --
    -- The product AB is then obtained as follows:
    --
    --   to obtain the 1,1 entry of AB, multiply Row 1 of A by Column 1 of B.
    --   to obtain the 1,2 entry of AB, multiply Row 1 of A by Column 2 of B.
    --   to obtain the 1,3 entry of AB, multiply Row 1 of A by Column 3 of B.
    --   . . .
    --   to obtain the 2,1 entry of AB, multiply Row 2 of A by Column 1 of B.
    --   to obtain the 2,2 entry of AB, multiply Row 2 of A by Column 1 of B.
    --  and so on. In general,
    --   to obtain the i,j entry of AB, multiply Row i of A by Column j of B.
    --------------------------------------------------------------------------------

    -- multiplicação de duas matrizes binárias
    function "*"(m1: bit_matrix; m2: bit_matrix) return bit_matrix is
        variable result: bit_matrix(m1'range(1), m2'range(2));
        variable m1_row: bit_vector(m1'range(2));
        variable m2_col: bit_vector(m2'range(1));
    begin
        -- we can take the product AB only if the number of
        -- columns of A equals the number of rows of B
        assert width(m1) = height(m2);

        for i in result'range(1) loop
            m1_row := matrix_row(m1, i);
            for j in result'range(2) loop
                m2_col       := matrix_column(m2, j);
                --result(i, j) := elements_xor(
                result(i, j) := xor(
                    -- AND bit-a-bit entre o vetor 'v' e a coluna 'j' da matriz
                    m1_row and m2_col
                );
            end loop;
        end loop;

        return result;
    end function;

    function shift_left_matrix(matrix: bit_matrix; new_column: bit_vector) return bit_matrix is
        variable final: bit_matrix(matrix'range(1), matrix'range(2));
    begin
        for i in matrix'range(1) loop
            for j in matrix'range(2) loop
                if j < width(matrix) then
                    final(i, j) := matrix(i, j + 1);
                else
                    final(i, j) := new_column(i);
                end if;
            end loop;
        end loop;

        return final;
    end;

    function shift_left(matrix: bit_matrix) return bit_matrix is
        variable shifted_matrix: bit_matrix(matrix'range(1), matrix'range(2));
    begin
        -- for each matrix row
        for i in matrix'range(1) loop
            -- for each matrix column
            for j in matrix'range(2) loop
                -- is this the last column?
                if j < width(matrix) then
                    shifted_matrix(i, j) := matrix(i, j + 1);
                else
                    shifted_matrix(i, j) := '0';
                end if; -- is this the last column?
            end loop; -- for each matrix column
        end loop; -- for each matrix row

        return shifted_matrix;
    end; -- function shift_left
    

    function shift_left(matrix: bit_matrix; shift_amount: natural) return bit_matrix is
        variable shifted_matrix: matrix'subtype;
        constant NONZERO_COLUMNS_COUNT: natural := width(matrix) - shift_amount + 1;
    begin
        -- for each matrix row
        for i in matrix'range(1) loop
            -- for each matrix column
            for j in matrix'range(2) loop
                -- copy element or fill it with zero
                if j < NONZERO_COLUMNS_COUNT then
                    shifted_matrix(i, j) := matrix(i, j + shift_amount);
                else -- j >= NONZERO_COLUMNS_COUNT
                    shifted_matrix(i, j) := '0';
                end if; -- copy element or fill it with zero
            end loop; -- for each matrix column
        end loop; -- for each matrix row

        return shifted_matrix;
    end; -- function shift_left


    function height(matrix: bit_matrix) return integer is
    begin
        return matrix'length(1);
    end function;

    function width(matrix: bit_matrix) return integer is
    begin
        return matrix'length(2);
    end function;

    procedure inspect(matrix: bit_matrix; tag: string := "") is
        variable row: line(matrix'range(2));
        variable tag_text: line;
    begin
        if tag /= "" then
            write(tag_text, tag & " ");
            writeline(output, tag_text);
        end if;
        for i in matrix'range(1) loop
            write(row, matrix_row(matrix, i));
            writeline(output, row);
        end loop;
    end procedure;

end package body;
