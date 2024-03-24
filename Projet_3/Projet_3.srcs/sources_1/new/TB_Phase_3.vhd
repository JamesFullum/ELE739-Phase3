----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2024 07:40:08 PM
-- Design Name: 
-- Module Name: TB_Phase_3 - Testbench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Phase_3 is
end TB_Phase_3;

architecture Testbench of TB_Phase_3 is
  -- Définition des paramètres génériques du module testé en constantes 
  -- Coefficients du filtre FIR pour le sinus
  constant G_H_0_S : integer  := 15; 
  constant G_H_1_S : integer  := 15; 
  constant G_H_2_S : integer  := 15; 
  constant G_H_3_S : integer  := 15; 
  constant G_H_4_S : integer  := -15; 
  constant G_H_5_S : integer  := -15; 
  constant G_H_6_S : integer  := -15; 
  constant G_H_7_S : integer  := -15; 
  -- Coefficients du filtre FIR pour le cosinus
  constant G_H_0_C : integer  := 31; 
  constant G_H_1_C : integer  := 31; 
  constant G_H_2_C : integer  := 31; 
  constant G_H_3_C : integer  := 31; 
  constant G_H_4_C : integer  := -31; 
  constant G_H_5_C : integer  := -31; 
  constant G_H_6_C : integer  := -31; 
  constant G_H_7_C : integer  := -31; 
  -- Nombre d'échantillons a prendre
  constant NB_ECHANTILLON : positive := 16;
  -- Taille de la sortie du generateur de signal
  constant BIT_WIDTH      : positive := 8;
  -- Taille de la sortie du module
  constant BUS_SIZE       : positive := 16;
  
  
  -- Déclaration du composant à tester
  component DUT is
    generic (
       -- Coefficients du filtre FIR pour le sinus
       G_H_0_S          : integer  := 10;
       G_H_1_S          : integer  := 10;
       G_H_2_S          : integer  := 10;
       G_H_3_S          : integer  := 10;
       G_H_4_S          : integer  := 10;
       G_H_5_S          : integer  := 10;
       G_H_6_S          : integer  := 10;
       G_H_7_S          : integer  := 10;
       -- Coefficients du filtre FIR pour le cosinus    
       G_H_0_C          : integer  := 10;
       G_H_1_C          : integer  := 10;
       G_H_2_C          : integer  := 10;
       G_H_3_C          : integer  := 10;
       G_H_4_C          : integer  := 10;
       G_H_5_C          : integer  := 10;
       G_H_6_C          : integer  := 10;
       G_H_7_C          : integer  := 10; 
       -- Nombre d'échantillons a prendre
       NB_ECHANTILLON : positive := 16;
       -- Taille de la sortie du generateur de signal
       BIT_WIDTH      : positive :=  8;
       -- Taille de la sortie du module
       BUS_SIZE       : positive := 16
    );
    port (
       i_clk      : in  std_logic; -- Horloge du module
       RESET_G    : in  std_logic; -- Reset du module   
       i_cen      : in  std_logic; -- Enable de l'horloge
       i_switch   : in  std_logic_vector(1 downto 0); -- Interrupteur pour changer le mode de sortiedu module 
       BUS_SORTIE : out std_logic_vector(BUS_SIZE-1 downto 0) -- La sortie du module
    );
    end component;
    
    -- Définition des ports du module testé en signaux
    signal clk        : std_logic;
    signal reset      : std_logic;  
    signal cen        : std_logic;
    signal switch     : std_logic_vector(1 downto 0);
    signal BUS_SORTIE : std_logic_vector(BUS_SIZE-1 downto 0);

begin
--------------------------------------------------------------------------------
-- Simulation de l'horloge et du reset
--------------------------------------------------------------------------------
  clk_gen : process
  begin
    -- Simulation d'une horloge de 50MHz avec un taux de charge de 50%
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
  end process clk_gen;

  reset_gen : process
  begin
     reset <= '1';
     wait for 100 ns;
     reset <= '0';
     wait for 35000 ns;
  end process;

--------------------------------------------------------------------------------
-- Simulation des stimuli
--------------------------------------------------------------------------------
  main : process
  begin
    cen    <= '1';
    switch <= "00";
    wait for 40000 ns;
    switch <= "01";
    wait for 40000 ns;
    switch <= "10";
    wait for 40000 ns;
    switch <= "11";
    wait for 40000 ns;
  end process;

--------------------------------------------------------------------------------
-- Configuration du module à tester
--------------------------------------------------------------------------------
    DUT_INST : DUT
        generic map (
            G_H_0_S => G_H_0_S,
            G_H_1_S => G_H_1_S,
            G_H_2_S => G_H_2_S,
            G_H_3_S => G_H_3_S,
            G_H_4_S => G_H_4_S,
            G_H_5_S => G_H_5_S,
            G_H_6_S => G_H_6_S,
            G_H_7_S => G_H_7_S,
            G_H_0_C => G_H_0_C,
            G_H_1_C => G_H_1_C,
            G_H_2_C => G_H_2_C,
            G_H_3_C => G_H_3_C,
            G_H_4_C => G_H_4_C,
            G_H_5_C => G_H_5_C,
            G_H_6_C => G_H_6_C,
            G_H_7_C => G_H_7_C
        )
        port map (
            i_clk      => clk,
            RESET_G    => reset,
            i_cen      => cen,
            i_switch   => switch,
            BUS_SORTIE => BUS_SORTIE
        );

end Testbench;
