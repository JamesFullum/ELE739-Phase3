--------------------------------------------------------------------------------
-- Titre      : Top Experimental - Phase 2
-- Projet     : ELE739 - Phase 2
--------------------------------------------------------------------------------
-- Fichier    : Top_Exp.vhd
-- Auteur     : James
-- Création   : 2024-03-03
--------------------------------------------------------------------------------
-- Description : Top physique pour implémenter sur la carte Basys3
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;     -- Pour les types signed et unsigned

entity Top_Exp is
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
    clk  : in  std_logic; -- Horloge du Basys3
    btnC : in  std_logic; -- Bouton pour le reset
    sw   : in  std_logic_vector(1 downto 0); -- Interrupteur pour contrôler la sortie du module
    led  : out std_logic_vector(15 downto 0)
  );
  
end Top_Exp;

architecture rtl of Top_Exp is

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

    -- Declaration du ILA
    component ila_0
        port(
            clk    : in std_logic;
            probe0 : in std_logic;
            probe1 : in std_logic_vector(1 downto 0);
            probe2 : in std_logic_vector(BUS_SIZE-1 downto 0)      
        );
    end component;
    
    -- Signaux internes du Top Experimental
    signal BUS_SORTIE_int : std_logic_vector(BUS_SIZE-1 downto 0);

begin

    led         <= BUS_SORTIE_int;

    -- Instantiation du module
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
            RESET_G    => btnC,
            i_cen      => '1',
            i_switch   => sw,
            BUS_SORTIE => BUS_SORTIE_int
        );

     -- Instantiation du ILA
     ILA_INST : ila_0
        port map(
            clk     => clk,
            probe0  => btnC,
            probe1  => sw,
            probe2  => BUS_SORTIE_int  
        );

end rtl;
