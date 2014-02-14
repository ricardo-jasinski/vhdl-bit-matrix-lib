use work.bit_vector_pkg.all;
use work.tbu_bdd_pkg.all;

entity bit_vector_pkg_tb is
end entity bit_vector_pkg_tb;

architecture testbench of bit_vector_pkg_tb is begin

  test_null_bit_vector: process is begin
    describe("null_bit_vector");

    should("generate a null vector with 1 element",
      null_bit_vector(1) = "0"
    );
    should("generate a null vector with 3 elements (compare with string)",
      null_bit_vector(3) = "000"
    );
    should("generate a null vector with 3 elements (compare with array)",
      null_bit_vector(3) = ('0', '0', '0')
    );

    done;
  end process;

  test_zeroes: process is begin
    describe("zeroes");

    should("generate a null vector with 1 element",
      zeroes(1) = "0"
    );
    should("generate a null vector with 3 elements",
      zeroes(3) = "000"
    );

    done;
  end process;

  test_unit_vector: process is begin
    describe("unit_vector");

    should("generate a unit vector with 1 element",
      unit_vector(1,1) = "1"
    );
    should("generate a unit vector with 4 elements",
      unit_vector(4,2) = "0100"
    );

    done;
  end process;

  test_ones: process is begin
    describe("ones");

    should("generate a vector with 1 element with value 1",
      ones(1) = "1"
    );
    should("generate a vector with 3 elements with value 1",
      ones(3) = "111"
    );

    done;
  end process;

  test_elements_and: process is begin
    describe("elements_and");

    should("return 0 when all bits are 0",
      elements_and("000") = '0'
    );
    should("return 1 when all bits are 1",
      elements_and("111") = '1'
    );
    should("return 0 when a single bit is 0",
      elements_and("1110") = '0'
    );

    done;
  end process;

  test_elements_or: process is begin
    describe("elements_or");

    should("return 0 when all bits are 0",
      elements_and("000") = '0'
    );
    should("return 1 when all bits are 1",
      elements_and("111") = '1'
    );
    should("return 1 when a single bit is 1",
      elements_and("0001") = '0'
    );

    done;
  end process;

  test_elements_xor: process is begin
    describe("elements_xor");

    should("return 0 when all bits are 0",
      elements_and("000") = '0'
    );
    should("return 1 when an odd number of bits are 1",
      elements_and("111") = '1'
    );
    should("return 0 when an even number of bits are 1",
      elements_and("101") = '0'
    );

    done;
  end process;

  test_integer_from_bit_vector: process is begin
    describe("integer_from_bit_vector");

    should("return 0 for 4 bits 0",
      integer_from_bit_vector("0000") = 0
    );
    should("return 1 for 001",
      integer_from_bit_vector("001") = 1
    );
    should("return 90 for 01011010",
      integer_from_bit_vector("01011010") = 90
    );

    done;
  end process;

  test_it_vector_from_integer : process is begin
    describe("bit_vector_from_integer");

    should("return 0000 for a value 0 with lenght 4",
      bit_vector_from_integer(0, 4) = "0000"
    );
    should("return 001 for a value 1 with length 3",
      bit_vector_from_integer(1, 3) = "001"
    );
    should("return 01011010 for a value 90 with length 8",
      bit_vector_from_integer(90, 8) = "01011010"
    );

    done;
  end process;

end architecture testbench;
