defmodule ConditionParserTest do
  use ExUnit.Case

  alias Ottr.Utils.ConditionParser

  # === Case 1: Basic comparison & logical AND
  @context_case_1 %{
    "user" => %{
      "age" => 25,
      "verified" => true
    }
  }
  @expr_case_1 "user.age >= 18 and user.verified == true"

  test "case 1: basic and comparison" do
    assert ConditionParser.eval(@expr_case_1, @context_case_1) == true
  end

  # === Case 2: Logical OR
  @context_case_2 %{
    "user" => %{
      "age" => 16,
      "verified" => true
    }
  }
  @expr_case_2 "user.age >= 18 or user.verified == true"

  test "case 2: logical or" do
    assert ConditionParser.eval(@expr_case_2, @context_case_2) == true
  end

  # === Case 3: Parentheses grouping
  @context_case_3 %{
    "user" => %{
      "age" => 17,
      "verified" => false,
      "admin" => true
    }
  }
  @expr_case_3 "user.age >= 18 and (user.verified == true or user.admin == true)"

  test "case 3: parentheses grouping" do
    assert ConditionParser.eval(@expr_case_3, @context_case_3) == true
  end

  # TODO: [INFO]: Passed 'till here

  # === Case 4: Not operator
  @context_case_4 %{
    "user" => %{
      "disabled" => false
    }
  }
  @expr_case_4 "not user.disabled"

  test "case 4: not operator" do
    assert ConditionParser.eval(@expr_case_4, @context_case_4) == true
  end

  # === Case 5: Inclusion (in)
  @context_case_5 %{
    "user" => %{
      "role" => "editor"
    }
  }
  @expr_case_5 "user.role in [\"admin\", \"editor\"]"

  test "case 5: inclusion in list" do
    assert ConditionParser.eval(@expr_case_5, @context_case_5) == true
  end

  # === Case 6: Custom function - includes/2
  @context_case_6 %{
    "user" => %{
      "tags" => ["beta", "verified"]
    }
  }
  @expr_case_6 "includes(user.tags, \"verified\")"

  test "case 6: includes function" do
    assert ConditionParser.eval(@expr_case_6, @context_case_6) == true
  end

  # === Case 7: Arithmetic
  @context_case_7 %{
    "user" => %{
      "age" => 20
    }
  }
  @expr_case_7 "user.age + 5 >= 25"

  test "case 7: arithmetic comparison" do
    assert ConditionParser.eval(@expr_case_7, @context_case_7) == true
  end

  # === Case 8: starts_with function
  @context_case_8 %{
    "user" => %{
      "email" => "admin@example.com"
    }
  }
  @expr_case_8 "starts_with(user.email, \"admin\")"

  test "case 8: starts_with function" do
    assert ConditionParser.eval(@expr_case_8, @context_case_8) == true
  end

  # === Case 9: Missing key should not crash
  @context_case_9 %{
    "user" => %{
      "name" => "Bob"
    }
  }
  @expr_case_9 "user.age >= 18"

  test "case 9: missing key fallback" do
    assert ConditionParser.eval(@expr_case_9, @context_case_9) in [false, nil]
  end

  # === Case 10: Type coercion
  @context_case_10 %{
    "user" => %{
      "age" => 25
    }
  }
  @expr_case_10 "user.age == \"25\""

  test "case 10: type coercion" do
    assert ConditionParser.eval(@expr_case_10, @context_case_10) == true
  end
end
