--------------------------------------------------------------------------------
-- Titre    : Generateur de signal cosinus
-- Projet   : ELE739 Phase 2
-------------------------------------------------------------------------------
-- Fichier  : Gen_Cos.vhd
-- Auteur   : Guillaume
-- Cr�ation : 2024-02-27
--------------------------------------------------------------------------------
-- Description : Generateur de signal pour le cosinus
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gen_Cos is
  generic (
           NB_ECHANTILLON : positive := 16;    --Nombre d'�chantillon pour une p�riode compl�te du cosinus   
           BIT_WIDTH      : positive := 8      --Nombre de bits pour repr�senter l'amplitude
  );
  
  Port ( 
        i_clk     : in std_logic;
        RESET_G   : in std_logic;                       --Reset global controll� par un bouton
        i_cen     : in std_logic;
        i_mode    : in std_logic_vector(1 downto 0);
        o_cos     : out signed (BIT_WIDTH-1 downto 0)   --Signal de sortie �chantillonn� du cosinus (Amplitude)
  );
end Gen_Cos;

architecture rtl of Gen_Cos is
    signal echantillon_index    : natural range 0 to NB_ECHANTILLON-1 :=0;           -- Intervalle d'�chantillonnage
    
    signal mode_del  : std_logic_vector(1 downto 0);
    signal mode_chng : std_logic;
    
    type   tableau_cosinus is array (0 to NB_ECHANTILLON-1) of signed(7 downto 0);     -- Tableau contenant les valeurs d'amplitude  
    signal cos_s : tableau_cosinus := (
        "01111111", -- nouveau = 127 =           127
        "01101111", -- nouveau = 111 = sqrt(3)/2*127
        "01011011", -- nouveau = 91  = sqrt(2)/2*127
        "01000000", -- nouveau = 64  =       1/2*127
        "00000000", -- 0
        "11000000", -- nouveau =-64 =      -1/2*127
        "10100101", -- nouveau =-91 =-sqrt(2)/2*127
        "10010001", -- nouveau =-111=-sqrt(3)/2*127
        "10000001", -- nouveau =-127=        -128+1
        "10010001", -- nouveau =-111=-sqrt(3)/2*127
        "10100101", -- nouveau =-91 =-sqrt(2)/2*127
        "11000000", -- nouveau =-64 =      -1/2*127
        "00000000", -- 0
        "01000000", -- nouveau = 64 =       1/2*127
        "01011011", -- nouveau = 91 = sqrt(2)/2*127
        "01101111"  -- nouveau = 111= sqrt(3)/2*127
        );
    -- Le MSB a gauche est le bit de signe, le point se situe entre le 1ere et 2eme bit ce qui donne une variation de [0.992187;-0.992187]

begin
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' or mode_chng = '1'  then
                echantillon_index <= 0;
                o_cos <= cos_s(0);
            else
                if i_cen = '1' then
                   o_cos <= cos_s(echantillon_index);
                   echantillon_index <= (echantillon_index+1) mod NB_ECHANTILLON;
                end if;   
            end if;
        end if; 
    end process;
    
    -- Remettre le g�nrateur � cos[0] si le filtre est activer/d�sactiver
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                mode_del <= (others => '0');
            else
                if i_cen = '1' then
                    mode_del <= i_mode;
                end if;
            end if;
        end if;
    end process;    
    
    mode_chng <= (mode_del(1) xor i_mode(1)) and (mode_del(0) xor i_mode(0));
      
end rtl;