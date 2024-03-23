--------------------------------------------------------------------------------
-- Titre    : DUT pour la phase 3
-- Projet   : ELE739 Phase 3
--------------------------------------------------------------------------------
-- Fichier  : DUT.vhd
-- Auteur   : James
-- Création : 2024-03-20
--------------------------------------------------------------------------------
-- Description : Entité complet pour la phase 3
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DUT is
  -- La section generic contient les paramètres de configuration du module.
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

  -- La section port contient les entrées-sorties du module.
  port (
    i_clk      : in  std_logic;
    RESET_G    : in  std_logic;
    i_cen      : in  std_logic;
    i_switch   : in  std_logic_vector(1 downto 0);
    BUS_SORTIE : out std_logic_vector(BUS_SIZE-1 downto 0)
  );
end DUT;

architecture rtl of DUT is
    
    -- Déclaration du composant pour le filtre du signal cosinus
    component FIR_Cos is
        generic (
            G_H_0 : integer;
            G_H_1 : integer;
            G_H_2 : integer;
            G_H_3 : integer;
            G_H_4 : integer;
            G_H_5 : integer;
            G_H_6 : integer; 
            G_H_7 : integer    
        );
        port (
            i_clk   : in  std_logic;
            RESET_G : in  std_logic;
            i_cen   : in  std_logic;
            i_fen   : in  std_logic;
            i_cos   : in  signed(7  downto 0);
            o_cos_f : out signed(15 downto 0)
        );
    end component;
    
    -- Déclaration du composant pour le filtre du signal cosinus
    component FIR_Sin is
        generic (
            G_H_0 : integer;
            G_H_1 : integer;
            G_H_2 : integer;
            G_H_3 : integer;
            G_H_4 : integer;
            G_H_5 : integer;
            G_H_6 : integer; 
            G_H_7 : integer    
        );
        port (
            i_clk_slow : in  std_logic;
            i_clk_fast : in   std_logic;
            RESET_G    : in  std_logic;
            i_cen      : in  std_logic;
            i_fen      : in  std_logic;
            i_sin      : in  signed(7  downto 0);
            o_sin_f    : out signed(15 downto 0)
        );
    end component;

    -- Déclaration du composant pour le Générateur de Cosinus
    component Gen_Cos is        
        generic(
            NB_ECHANTILLON : positive;
            BIT_WIDTH      : positive
        );
        port (
            i_clk   : in  std_logic;
            RESET_G : in  std_logic;
            i_cen   : in  std_logic;
            i_mode  : in  std_logic_vector(1 downto 0);
            o_cos   : out signed(7 downto 0)
        );
    end component;

    -- Déclaration du composant pour le Générateur de Sinus
    component Gen_Sin is        
        generic(
            NB_ECHANTILLON : positive;
            BIT_WIDTH      : positive
        );
        port (
            i_clk   : in  std_logic;
            RESET_G : in  std_logic;
            i_cen   : in  std_logic;
            i_fen   : in  std_logic;
            o_sin   : out signed(7 downto 0)
        );
    end component;

    -- Déclaration du composant pour le MMCM
    component MMCM is
        port (
            reset    : in std_logic;
            clk_in1  : in std_logic;
            clk_out1 : out std_logic;
            clk_out2 : out std_logic;
            locked   : out std_logic
        );
    end component;
    
    -- Déclaration du composant pour le Multiplexeur de Sortie
    component Mux is
        generic (  
            BIT_WIDTH       : positive;      --Nombre de bits pour représenter l'amplitude
            BUS_SIZE        : positive      --Nombre de bits pour le BUS DE SORTIE
        );
        port ( 
            i_clk            : in  std_logic;
            RESET_G          : in  std_logic;
            i_cen            : in  std_logic;
            i_mode           : in  std_logic_vector(1 downto 0);
            i_cos_generateur : in  signed(BIT_WIDTH-1 downto 0);
            i_cos_filtre     : in  signed(BUS_SIZE-1 downto 0);
            i_sin_filtre     : in  signed(BUS_SIZE-1 downto 0);
            o_cos_fen        : out std_logic;
            o_sin_fen        : out std_logic;
            BUS_SORTIE       : out std_logic_vector(BUS_SIZE-1 downto 0)
        );
    end component;
    
    signal slow_clk_int : std_logic;
    signal fast_clk_int : std_logic;
    
    signal cos_gen_int : signed(7  downto 0);
    signal sin_gen_int : signed(7  downto 0);
    signal cos_fir_int : signed(15 downto 0);
    signal sin_fir_int : signed(15 downto 0); 
    signal cos_fen_int : std_logic;
    signal sin_fen_int : std_logic;
    
    signal locked : std_logic;
    
begin

    -- Instantiation du FIR pour le cosinus
    FIR_COS_INST : FIR_COS
        generic map(
            G_H_0 => G_H_0_C,
            G_H_1 => G_H_1_C,
            G_H_2 => G_H_2_C,
            G_H_3 => G_H_3_C,
            G_H_4 => G_H_4_C,
            G_H_5 => G_H_5_C,
            G_H_6 => G_H_6_C,
            G_H_7 => G_H_7_C
        )
        port map(
            i_clk   => slow_clk_int,
            RESET_G => RESET_G,
            i_cen   => i_cen,
            i_fen   => cos_fen_int,
            i_cos   => cos_gen_int,
            o_cos_f => cos_fir_int
        );
        
    -- Instantiation du FIR pour le sinus
    FIR_SIN_INST : FIR_SIN
        generic map(
            G_H_0 => G_H_0_S,
            G_H_1 => G_H_1_S,
            G_H_2 => G_H_2_S,
            G_H_3 => G_H_3_S,
            G_H_4 => G_H_4_S,
            G_H_5 => G_H_5_S,
            G_H_6 => G_H_6_S,
            G_H_7 => G_H_7_S
        )
        port map(
            i_clk_slow => slow_clk_int,
            i_clk_fast => fast_clk_int,
            RESET_G => RESET_G,
            i_cen   => i_cen,
            i_fen   => sin_fen_int,
            i_sin   => sin_gen_int,
            o_sin_f => sin_fir_int
        );


    -- Instantiation du Générateur de Cosinus
    Gen_Cos_INST : Gen_Cos
        generic map(
            NB_ECHANTILLON => NB_ECHANTILLON,
            BIT_WIDTH      => BIT_WIDTH
        )       
        port map(
            i_clk   => slow_clk_int,
            RESET_G => RESET_G,
            i_mode  => i_switch,
            i_cen   => i_cen,
            o_cos   => cos_gen_int
        );
        
        -- Instantiation du Générateur de Cosinus
    Gen_Sin_INST : Gen_Sin
        generic map(
            NB_ECHANTILLON => NB_ECHANTILLON,
            BIT_WIDTH      => BIT_WIDTH
        )       
        port map(
            i_clk   => slow_clk_int,
            RESET_G => RESET_G,
            i_fen   => sin_fen_int,
            i_cen   => i_cen,
            o_sin   => sin_gen_int
        );
            
    -- Instantiation du Multiplexeur de Sortie
    Mux_INST : Mux        
        generic map(  
            BIT_WIDTH    => BIT_WIDTH,   --Nombre de bits pour représenter l'amplitude
            BUS_SIZE     => BUS_SIZE     --Nombre de bits pour le BUS DE SORTIE
        )
        port map(
            i_clk            => slow_clk_int,
            i_cen            => i_cen,
            RESET_G          => RESET_G,
            i_mode           => i_switch,
            i_cos_generateur => cos_gen_int,
            i_cos_filtre     => cos_fir_int, 
            i_sin_filtre     => sin_fir_int, 
            o_cos_fen        => cos_fen_int,
            o_sin_fen        => sin_fen_int,
            BUS_SORTIE       => BUS_SORTIE
        );
        
    MMCM_INST : MMCM
        port map(
            reset    => RESET_G,
            clk_in1  => i_clk,
            clk_out1 => fast_clk_int,
            clk_out2 => slow_clk_int,
            locked   => locked
        );
    


end rtl;
