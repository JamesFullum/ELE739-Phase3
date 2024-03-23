--------------------------------------------------------------------------------
-- Titre    : FIR
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : FIR.vhd
-- Auteur   : James
-- Création : 2024-02-13
--------------------------------------------------------------------------------
-- Description : FIR à étages multiples de pipeline
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity FIR_Sin is
  -- La section generic contient les paramètres de configuration du module.
  generic (
    -- Coefficients du filtre
    G_H_0       : integer := 10;
    G_H_1       : integer := 10;
    G_H_2       : integer := 10;
    G_H_3       : integer := 10;
    G_H_4       : integer := 10;
    G_H_5       : integer := 10;
    G_H_6       : integer := 10;
    G_H_7       : integer := 10   
  );

  -- La section port contient les entrées-sorties du module.
  port (
    i_clk_slow  : in std_logic;            -- Horloge du filtre
    i_clk_fast  : in std_logic;
    RESET_G : in  std_logic;            -- Reset du filtre
    i_cen   : in  std_logic;            -- Enable de l'horloge
    i_fen   : in  std_logic;            -- Enable du filtre
    i_sin   : in  signed(7  downto 0);  -- Entree de la generateur du signal
    o_sin_f : out signed(15 downto 0)   -- Sortie du filtre
  );
end;

architecture rtl of FIR_Sin is

   -- Array pour les donnees
   type t_sin is array (7 downto 0) of signed(7 downto 0);
   signal sin_int : t_sin;
   
   -- Array pour les coefficients du filtre
   type t_h is array (7 downto 0) of signed(5 downto 0);
   signal h_int : t_h;
   
   signal cmptr_int : unsigned(2 downto 0);
   signal coeff_int : signed(5 downto 0);
   signal data_int  : signed(7 downto 0);

   signal mult_int  : signed(13 downto 0);
   signal acc_int   : signed(15 downto 0);
   signal outad_int : signed(15 downto 0);
   
begin


------------------------------------------
---    Assignation des coefficients    ---
------------------------------------------
    h_int(0) <= to_signed(G_H_0,h_int(0)'length);
    h_int(1) <= to_signed(G_H_1,h_int(1)'length);
    h_int(2) <= to_signed(G_H_2,h_int(2)'length);
    h_int(3) <= to_signed(G_H_3,h_int(3)'length);
    h_int(4) <= to_signed(G_H_4,h_int(4)'length);
    h_int(5) <= to_signed(G_H_5,h_int(5)'length);
    h_int(6) <= to_signed(G_H_6,h_int(6)'length);
    h_int(7) <= to_signed(G_H_7,h_int(7)'length);

-------------------------------------
---    Propogation des Donnees    ---
------------------------------------- 
    process(i_clk_slow)
    begin
        if rising_edge(i_clk_slow) then
            if RESET_G = '1' or i_fen = '0' then
                for i in 0 to 7 loop
                    sin_int(i) <= (others => '0');
                end loop;
            else
                if i_cen = '1' and i_fen = '1' then
                    sin_int(0) <= i_sin;
                    for i in 0 to 6 loop
                        sin_int(i+1) <= sin_int(i);
                    end loop;
                end if;
            end if; 
        end if;
    end process;
    
-------------------------------------
---           Compteurs           ---
------------------------------------- 
    process(i_clk_fast)
    begin
        if rising_edge(i_clk_fast) then 
            if RESET_G = '1' or i_fen = '0' then
                cmptr_int <= (others => '0');
            else
                if i_cen = '1' then
                    cmptr_int <= cmptr_int+1;
                end if;
            end if;
        end if;
    end process;
    
-------------------------------------
---         Multiplexeurs         ---
------------------------------------- 
    process(cmptr_int)
    begin 
        case cmptr_int is
            when "000" =>
                data_int  <= sin_int(0);
                coeff_int <= h_int(0);
            when "001" =>
                data_int  <= sin_int(1);
                coeff_int <= h_int(1);   
            when "010" =>
                data_int  <= sin_int(2);
                coeff_int <= h_int(2);   
            when "011" =>
                data_int  <= sin_int(3);
                coeff_int <= h_int(3);   
            when "100" =>
                data_int  <= sin_int(4);
                coeff_int <= h_int(4);   
            when "101" =>
                data_int  <= sin_int(5);
                coeff_int <= h_int(5);   
            when "110" =>
                data_int  <= sin_int(6);
                coeff_int <= h_int(6);   
            when "111" =>
                data_int  <= sin_int(7);
                coeff_int <= h_int(7);   
            when others =>
                data_int  <= (others => '0');
                coeff_int <= (others => '0');   
        end case;
    end process;

-------------------------------------
---   Multiplication+Addition     ---
------------------------------------- 

    mult_int  <= data_int*coeff_int;
    outad_int <= acc_int+mult_int;

-------------------------------------
---         Accumulation          ---
------------------------------------- 
    process(i_clk_fast)
    begin
        if rising_edge(i_clk_fast) then
            if RESET_G = '1' or i_fen = '0' then
                acc_int   <= (others => '0');
            else
                if i_cen = '1' then
                    acc_int   <= outad_int;
                end if;
            end if;
        end if;
    end process;
   
-------------------------------------
---            Sortie             ---
-------------------------------------     
    process(i_clk_slow)
    begin
        if rising_edge(i_clk_slow) then
            if RESET_G = '1' or i_fen = '0' then
                o_sin_f <= (others => '0');
            else
                if i_cen = '1' then
                    o_sin_f <= outad_int;
                end if;
            end if;
        end if;    
    end process;    
    
end architecture;