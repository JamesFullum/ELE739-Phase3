--------------------------------------------------------------------------------
-- Titre    : Generateur de signal sinus
-- Projet   : ELE739 Phase 3
--------------------------------------------------------------------------------
-- Fichier  : Gen_Sin.vhd
-- Auteur   : James
-- Création : 2024-03-20
--------------------------------------------------------------------------------
-- Description : Generateur de signal pour le sinus
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gen_Sin is
  generic (
           NB_ECHANTILLON : positive := 16;    --Nombre d'échantillon pour une période complète du cosinus   
           BIT_WIDTH      : positive := 8      --Nombre de bits pour représenter l'amplitude
  );
  
  Port ( 
        i_clk     : in  std_logic;
        RESET_G   : in  std_logic;                       --Reset global controllé par un bouton
        i_cen     : in  std_logic;
        i_fen    : in  std_logic;
        o_sin     : out signed (BIT_WIDTH-1 downto 0)   --Signal de sortie échantillonné du cosinus (Amplitude)
  );
end Gen_Sin;

architecture rtl of Gen_Sin is
    signal echantillon_index    : natural range 0 to NB_ECHANTILLON-1 :=0;           -- Intervalle d'échantillonnage

    type   tableau_sinus is array (0 to NB_ECHANTILLON-1) of signed(7 downto 0);     -- Tableau contenant les valeurs d'amplitude  
    signal sin_s : tableau_sinus := (
        "00000000", -- 0
        "11000000", -- nouveau =-64  =      -1/2*127
        "10100101", -- nouveau =-91  =-sqrt(2)/2*127
        "10010001", -- nouveau =-111 =-sqrt(3)/2*127
        "10000001", -- nouveau =-127 =        -128+1
        "10010001", -- nouveau =-111 =-sqrt(3)/2*127
        "10100101", -- nouveau =-91  =-sqrt(2)/2*127
        "11000000", -- nouveau =-64  =      -1/2*127
        "00000000", -- 0
        "01000000", -- nouveau = 64  =       1/2*127
        "01011011", -- nouveau = 91  = sqrt(2)/2*127
        "01101111", -- nouveau = 111 = sqrt(3)/2*127
        "01111111", -- nouveau = 127 =           127
        "01101111", -- nouveau = 111 = sqrt(3)/2*127
        "01011011", -- nouveau = 91  = sqrt(2)/2*127
        "01000000"  -- nouveau = 64  =       1/2*127
        );
    -- Le MSB a gauche est le bit de signe, le point se situe entre le 1ere et 2eme bit ce qui donne une variation de [0.992187;-0.992187]

begin
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (RESET_G = '1') or not(i_fen = '1') then
                echantillon_index <= 0;
                o_sin <= sin_s(0);
            else
                if i_cen = '1' then
                   o_sin <= sin_s(echantillon_index);
                   echantillon_index <= (echantillon_index+1) mod NB_ECHANTILLON;
                end if;   
            end if;
        end if; 
    end process;
      
end rtl;