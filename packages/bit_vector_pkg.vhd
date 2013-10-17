package bit_vector_pkg is

  type integer_vector is array (natural range <>) of integer;

  -- retorna um vetor com a largura especificada e todos
  -- os elementos iguais a '0'
  function null_bit_vector(w: integer) return bit_vector;

  function zeroes(w: integer) return bit_vector;
  function ones(w: integer) return bit_vector;
  function unit_vector(size, nonzero_pos: integer) return bit_vector;
  function weight(v: bit_vector) return integer;

  -- operação AND entre os elementos de um vetor, retornando um bit
  function elements_and(v: bit_vector) return bit;

  -- operação OR entre os elementos de um vetor, retornando um bit
  function elements_or(v: bit_vector) return bit;

  -- operação XOR entre os elementos de um vetor, retornando um bit
  function elements_xor(v: bit_vector) return bit;

  -- cria um novo vetor, a partir de um subconjunto de elementos de um dado vetor
  function VectorFromVectorElements(v: bit_vector; e: integer_vector) return bit_vector;

  -- retorna um número inteiro a partir de um vetor de bits;
  -- elemento mais à direita (menor índice) é o menos significativo
  function integer_from_bit_vector(v: bit_vector) return integer;
  -- retorna um vetor de bits a partir de um número inteiro;
  -- elemento mais à direita (menor índice) é o menos significativo
  function bit_vector_from_integer(i: integer; w: integer) return bit_vector;

end package bit_vector_pkg;



package body bit_vector_pkg is

  -- retorna um vetor com a largura especificada e todos
  -- os elementos iguais a '0'
  function null_bit_vector(w: integer) return bit_vector is begin
    return zeroes(w);
  end function null_bit_vector;

  function zeroes(w: integer) return bit_vector is
    variable retVect: bit_vector(1 to w) := (others => '0');
  begin
    return retVect;
  end function;

  function ones(w: integer) return bit_vector is
    variable retVect: bit_vector(1 to w) := (others => '1');
  begin
    return retVect;
  end function;

  function unit_vector(size, nonzero_pos: integer) return bit_vector is
    variable result: bit_vector(1 to size) := (others => '0');
  begin
    result(nonzero_pos) := '1';
    return result;
  end function;

  -- cria um novo vetor, a partir de um subconjunto de elementos de um dado vetor
  function VectorFromVectorElements(v: bit_vector; e: integer_vector) return bit_vector is
    variable retVect: bit_vector(e'range);
  begin
    for i in e'range loop
      retVect(i) := v(e(i));
    end loop;
    return retVect;
  end function VectorFromVectorElements;

  function weight(v: bit_vector) return integer is
    variable result: integer := 0;
  begin
    for i in v'range loop
      if v(i) = '1' then
        result := result + 1;
      end if;
    end loop;
    return result;
  end function;

  -- operação XOR entre os elementos de um vetor, retornando um bit
  function elements_xor(v: bit_vector) return bit is
    variable result: bit;
  begin
    result := '0';
    for i in v'range loop
      result := result xor v(i);
    end loop;
    return result;
  end function;

  -- operação AND entre os elementos de um vetor, retornando um bit
  function elements_and(v: bit_vector) return bit is
    variable result: bit;
  begin
    result := '1';
    for i in v'range loop
      result := result and v(i);
    end loop;
    return result;
  end function;

  -- operação OR entre os elementos de um vetor, retornando um bit
  function elements_or(v: bit_vector) return bit is
    variable result: bit;
  begin
    result := '0';
    for i in v'range loop
      result := result or v(i);
    end loop;
    return result;
  end function;

  -- retorna um número inteiro a partir de um vetor de bits;
  -- elemento mais à direita (menor índice) é o menos significativo
  function integer_from_bit_vector(v: bit_vector) return integer is
    variable retVal: integer range 0 to (2 ** v'length) - 1;
  begin
    retVal := 0;
    for i in v'range loop
      if (v(i) = '1') then
        --retVal := retVal + 2 ** (v'high-i+1);
        retVal := retVal + 2 ** (v'high-i);
      end if;
    end loop;
    return retVal;
  end function;

  -- retorna um vetor de bits a partir de um número inteiro;
  -- elemento mais à direita (menor índice) é o menos significativo
  function bit_vector_from_integer(i: integer; w: integer) return bit_vector is
    variable retVect: bit_vector(1 to w) := (others => '0');
    variable temp: integer range 0 to 2**w-1 := 0;
  begin
    temp := i;
    for j in retVect'high-1 downto retVect'low-1 loop
      if (temp >= 2**j) then
        retVect(retVect'high-j) := '1';
        temp := temp - 2**j;
      else
        retVect(retVect'high-j) := '0';
      end if;
    end loop;
    return retVect;
  end function;

end package body;
