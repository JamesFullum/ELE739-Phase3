--------------------------------------------------------------------------------
-- Titre    : Mux
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Mux.vhd
-- Auteur   : Guillaume
-- Création : 2024-02-26
--------------------------------------------------------------------------------
-- Description : Multiplexeur pour les signaux de sorties
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux is
    generic (  
        BIT_WIDTH       : positive := 8;      --Nombre de bits pour représenter l'amplitude
        BUS_SIZE        : positive := 16      --Nombre de bits pour le BUS DE SORTIE
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
end Mux;

architecture rtl of Mux is

    signal BUS_SORTIE_int : std_logic_vector(BUS_SIZE-1 downto 0);
    signal cos_fen_int    : std_logic;
    signal sin_fen_int    : std_logic;

begin
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                BUS_SORTIE <= (others => '0');
                o_cos_fen  <= '0';
                o_sin_fen  <= '0';
            else 
                if i_cen = '1' then
                    BUS_SORTIE <= BUS_SORTIE_int; 
                    o_cos_fen  <= cos_fen_int;
                    o_sin_fen  <= sin_fen_int;
                end if;
            end if;
        end if;
    end process;
    
    process(i_mode, i_cos_filtre, i_cos_generateur,
    i_sin_filtre)
    begin
        case i_mode is
            when "00" =>
            -- Cosinus
                BUS_SORTIE_int(15 downto 8) <= std_logic_vector(i_cos_generateur);
                BUS_SORTIE_int(7 downto 0) <= (others => '0');
                cos_fen_int <= '0';
                sin_fen_int <= '0';
            when "01" =>
            -- Cosinus Filtré
                BUS_SORTIE_int <= std_logic_vector(i_cos_filtre);
                cos_fen_int <= '1';
                sin_fen_int <= '0';
            when "10" =>
            -- Sinus Filtré
                BUS_SORTIE_int <= std_logic_vector(i_sin_filtre);
                cos_fen_int <= '0';
                sin_fen_int <= '1';
            when others =>
                BUS_SORTIE_int <= (others => '0');
                cos_fen_int <= '0';
                sin_fen_int <= '0';
        end case;
    end process;
end rtl;
