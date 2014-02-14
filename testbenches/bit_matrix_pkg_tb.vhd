use work.bit_matrix_pkg.all;
use work.bit_vector_pkg.all;
use work.tbu_assert_pkg.all;
use work.tbu_bdd_pkg.all;

entity bit_matrix_pkg_tb is
end entity bit_matrix_pkg_tb;

architecture testbench of bit_matrix_pkg_tb is begin

  test_null_bit_matrix: process is begin
    describe("null_bit_matrix");

    should("generate a null 2x3 matrix",
      null_bit_matrix(2, 3) = ( "000", "000" )
    );

    done;
  end process;

  test_identity_bit_matrix: process is begin
    describe("identity_bit_matrix");

    should("generate a 2x2 identity matrix",
      identity_bit_matrix(2) = ( "10", "01" )
    );
    should("generate a 3x3 identity matrix",
      identity_bit_matrix(3) = ( "100", "010", "001" )
    );

    done;
  end process;

  test_width: process is begin
    describe("width");

    should("return the dimension of a square matrix",
      width(identity_bit_matrix(5)) = 5
    );
    should("return the number of columns of a matrix",
      width( ("10101", "01010") ) = 5
    );

    done;
  end process;

  test_matrix_column: process is begin
    describe("matrix_column");

    should("extract the n-th matrix column",
      matrix_column(identity_bit_matrix(3), 2) = "010"
    );

    done;
  end process;

  test_matrix_row: process is begin
    describe("matrix_row");

    should("extract the n-th matrix row",
      matrix_row(identity_bit_matrix(3), 2) = "010"
    );

    done;
  end process;

  test_exchange_rows: process is begin
    describe("exchange_rows");

    should("exchange the 1st and the 3rd rows",
      exchange_rows(identity_bit_matrix(4), 1, 3) = (
        "0010",
        "0100",
        "1000",
        "0001"
      )
    );

    done;
  end process;

  test_sub_matrix: process is begin
    describe("sub_matrix");

    should("slice the top right corner of a matrix",
      sub_matrix(identity_bit_matrix(4), 1, 3, 2, 4) = null_bit_matrix(2, 2)
    );

    should("slice the bottom right corner of a matrix",
      sub_matrix(identity_bit_matrix(4), 3, 3, 4, 4) = identity_bit_matrix(2)
    );

    done;
  end process;

  test_transpose: process is begin
    describe("transpose");

    should("transpose a matrix",
      transpose((
        "100",
        "111"
      )) = (
        "11",
        "01",
        "01"
      )
    );

    done;
  end process;

  test_shift_left_matrix: process is begin
    describe("shift_left_matrix");

    should("shift a matrix one position to the left and replace the rightmost column",
      shift_left_matrix( identity_bit_matrix(3), ones(3) ) = ("001", "101", "011")
    );

    done;
  end process;

  test_replace_matrix_column: process is begin
    describe("replace_matrix_column");

    should("replace the given column position with the given values",
      replace_matrix_column(("111", "111", "111"), "000", 1) = ("101", "101", "101")
    );

    done;
  end process;

  test_leftmost_columns: process is begin
    describe("leftmost_columns");

    should("return the leftmost columns of a matrix",
      leftmost_columns(identity_bit_matrix(3), 2) = ("10", "01", "00")
    );

    done;
  end process;

  test_rightmost_columns: process is begin
    describe("rightmost_columns");

    should("return the righmost columns of a matrix",
      rightmost_columns(identity_bit_matrix(3), 2) = ("00", "10", "01")
    );

    done;
  end process;

  test_vector_matrix_multiplication: process is begin
    describe("vector * matrix");

    should("return the given vector when multiplied by an identity matrix",
      ("101" * identity_bit_matrix(3)) = ("101")
    );
    should("return a null vector when multiplied by a null matrix",
      ("111" * null_bit_matrix(3,3)) = ("000")
    );

    done;
  end process;

  test_matrix_matrix_multiplication: process is begin
    describe("matrix * matrix");

    should("return an identity matrix when multiplied by itself",
      (identity_bit_matrix(3) * identity_bit_matrix(3)) = identity_bit_matrix(3)
    );
    should("return the original matrix when multiplied by an identity matrix",
      (("111","110","001") * ("100","010","001")) = to_bit_matrix(("111","110","001"))
    );

    done;
  end process;

end architecture testbench;
