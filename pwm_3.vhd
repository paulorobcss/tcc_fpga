library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity pwm_3 is
    generic (
        clk_rate                : integer := 50000);

    port (
        enable      : in std_logic;
        clk         : in std_logic;
        button      : in std_logic;
        switch      : in std_logic;
        led_1	     : out std_logic;
		  led_2	     : out std_logic;		  
		  led_3	     : out std_logic;		  
		  led_4	     : out std_logic;		  
        pwm_out     : out std_logic);
end pwm_3;

architecture behavior of pwm_3 is
	 constant bit_depth      : integer := integer(ceil(log2(real(clk_rate))));
    signal count_reg        : unsigned(bit_depth - 1 downto 0) := (others => '0');
    signal led_reg          : std_logic := '0';



    signal dc_rate_1        : integer := integer((clk_rate / 100) * 10);
    signal dc_rate_2        : integer := integer((clk_rate / 100) * 30);
    signal dc_rate_3        : integer := integer((clk_rate / 100) * 50);
    signal dc_rate_4        : integer := integer((clk_rate / 100) * 90);

    constant duty_cycle_1   : integer := integer(ceil(log2(real(dc_rate_1))));
    constant duty_cycle_2   : integer := integer(ceil(log2(real(dc_rate_2))));
    constant duty_cycle_3   : integer := integer(ceil(log2(real(dc_rate_3))));
    constant duty_cycle_4   : integer := integer(ceil(log2(real(dc_rate_4))));

    signal duty_cycle_reg_1 : unsigned(duty_cycle_1 - 1 downto 0) := to_unsigned(dc_rate_1, duty_cycle_1);
    signal duty_cycle_reg_2 : unsigned(duty_cycle_2 - 1 downto 0) := to_unsigned(dc_rate_2, duty_cycle_2);
    signal duty_cycle_reg_3 : unsigned(duty_cycle_3 - 1 downto 0) := to_unsigned(dc_rate_3, duty_cycle_3);
    signal duty_cycle_reg_4 : unsigned(duty_cycle_4 - 1 downto 0) := to_unsigned(dc_rate_4, duty_cycle_4);

    signal selector         : unsigned(2 downto 0) := "001";
    signal sel_led_1        : std_logic := '0';
    signal sel_led_2        : std_logic := '0';
    signal sel_led_3        : std_logic := '0';
    signal sel_led_4        : std_logic := '0';

    begin
        pwm_out <= led_reg;
        led_1 <= sel_led_1;
        led_2 <= sel_led_2;
        led_3 <= sel_led_3;
        led_4 <= sel_led_4;

        count_proc: process(clk)
        begin
            if rising_edge(clk) then
                if (enable = '0') or (count_reg = 50000) then
                    count_reg <= (others => '1');
                else
                    count_reg <= count_reg + 1;
                end if;
            end if;
        end process;

        button_proc: process(button)
        begin
            if (button = '1') then
                if selector = "001" then
                    if (switch = '1') then
                        selector <= "100";
                    else
                        selector <= selector + 1;
                    end if;
                end if;

                if selector = "010" then
                    if (switch = '1') then
                        selector <= selector - 1;
                    else
                        selector <= selector + 1;
                    end if;
                end if;

                if selector = "011" then
                    if (switch = '1') then
                        selector <= selector - 1;
                    else
                        selector <= selector + 1;
                    end if;
                end if;

                if selector = "100" then
                    if (switch = '1') then
                        selector <= selector - 1;
                    else
                        selector <= "001";
                    end if;
                end if;
            end if;
        end process;

        output_proc: process(clk)
        begin
            if rising_edge(clk) then
                if (selector = "001") then
                    sel_led_1 <= '1';
                    if (count_reg >= duty_cycle_reg_1) then
                        led_reg <= '0';
                    else
                        led_reg <= '1';
                    end if;
                else
                    sel_led_1 <= '0';
                end if;

                if (selector = "010") then
                    sel_led_2 <= '1';
                    if (count_reg >= duty_cycle_reg_2) then
                        led_reg <= '0';
                    else
                        led_reg <= '1';
                    end if;
                else
                    sel_led_2 <= '0';
                end if;

                if (selector = "011") then
                    sel_led_3 <= '1';
                    if (count_reg >= duty_cycle_reg_3) then
                        led_reg <= '0';
                    else
                        led_reg <= '1';
                    end if;
                else
                    sel_led_3 <= '0';
                end if;

                if (selector = "100") then
                    sel_led_4 <= '1';
                    if (count_reg >= duty_cycle_reg_4) then
                        led_reg <= '0';
                    else
                        led_reg <= '1';
                    end if;
                else
                    sel_led_4 <= '0';
                end if;
            end if;
        end process;
end behavior;