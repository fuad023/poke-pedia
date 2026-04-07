import React from "react";
import "../Style/PokemonDetailsPage.css";

type Stat = {
  label: string;
  value: number;
  max: number;
};

type PokedexEntry = {
  version: string;
  text: string;
};

type InfoItem = {
  label: string;
  value: string;
};

type EvolutionStage = {
  id: number;
  name: string;
  level?: string;
  image: string;
};

type ThemeType = {
  bodyBackground: string;
  accent: string;
  accentSoft: string;
  secondary: string;
  titleColor: string;
  textColor: string;
  cardBackground: string;
  hoverShadow: string;
  statNumberColor: string;
  statBarGradient: string;
  sectionLineGradient: string;
  entryVersionColor: string;
};

type PokemonType = {
  name: string;
  subtitle: string;
  pokemonId: number;
  mainImage: string;
  pokedexData: InfoItem[];
  training: InfoItem[];
  stats: Stat[];
  evolutions: EvolutionStage[];
  entries: PokedexEntry[];
};

const theme: ThemeType = {
  bodyBackground:
    "linear-gradient(135deg, #e8fff1 0%, #d8f6e7 45%, #eefbf3 100%)",
  accent: "#2f9e44",
  accentSoft: "#69db7c",
  secondary: "#4dabf7",
  titleColor: "#16351f",
  textColor: "#334155",
  cardBackground: "rgba(255, 255, 255, 0.88)",
  hoverShadow: "rgba(47, 158, 68, 0.22)",
  statNumberColor: "#2f9e44",
  statBarGradient:
    "linear-gradient(90deg, #2f9e44 0%, #69db7c 50%, #4dabf7 100%)",
  sectionLineGradient:
    "linear-gradient(90deg, #2f9e44 0%, #4dabf7 100%)",
  entryVersionColor: "#1971c2",
};

const pokemon: PokemonType = {
  name: "Bulbasaur",
  subtitle: "Seed Pokémon · Grass / Poison",
  pokemonId: 1,
  mainImage: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png",
  pokedexData: [
    { label: "National No.", value: "0001" },
    { label: "Species", value: "Seed Pokémon" },
    { label: "Type", value: "Grass / Poison" },
    { label: "Height", value: "0.7 m (2′04″)" },
    { label: "Weight", value: "6.9 kg (15.2 lbs)" },
    { label: "Abilities", value: "Overgrow, Chlorophyll" },
  ],
  training: [
    { label: "EV Yield", value: "1 Sp. Atk" },
    { label: "Catch Rate", value: "45" },
    { label: "Base Friendship", value: "50" },
    { label: "Growth Rate", value: "Medium Slow" },
  ],
  stats: [
    { label: "HP", value: 45, max: 255 },
    { label: "Attack", value: 49, max: 255 },
    { label: "Defense", value: 49, max: 255 },
    { label: "Sp. Atk", value: 65, max: 255 },
    { label: "Sp. Def", value: 65, max: 255 },
    { label: "Speed", value: 45, max: 255 },
  ],
  evolutions: [
    {
      id: 1,
      name: "Bulbasaur",
      image: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png",
    },
    {
      id: 2,
      name: "Ivysaur",
      level: "Level 16",
      image: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png",
    },
    {
      id: 3,
      name: "Venusaur",
      level: "Level 32",
      image: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png",
    },
  ],
  entries: [
    {
      version: "Red / Blue",
      text: "A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokémon.",
    },
  ],
};

const PokemonDetailsPage: React.FC = () => {
  const themeStyle = {
    "--body-bg": theme.bodyBackground,
    "--accent": theme.accent,
    "--accent-soft": theme.accentSoft,
    "--secondary": theme.secondary,
    "--title-color": theme.titleColor,
    "--text-color": theme.textColor,
    "--card-bg": theme.cardBackground,
    "--hover-shadow": theme.hoverShadow,
    "--stat-number-color": theme.statNumberColor,
    "--stat-bar-gradient": theme.statBarGradient,
    "--section-line-gradient": theme.sectionLineGradient,
    "--entry-version-color": theme.entryVersionColor,
  } as React.CSSProperties;

  return (
    <div className="pokemon-page" style={themeStyle}>
      <div className="pokemon-container">
        <header className="pokemon-header">
          <div className="pokemon-title-block">
            <p className="pokemon-subtitle">Pokémon Profile</p>
            <h1 className="pokemon-name">{pokemon.name}</h1>
            <p className="pokemon-tagline">{pokemon.subtitle}</p>
          </div>

          <div className="pokemon-hero-card">
            <img
              src={pokemon.mainImage}
              alt={pokemon.name}
              className="pokemon-main-image"
            />
          </div>
        </header>

        <section className="top-grid">
          <div className="card">
            <h2 className="section-title">Pokédex Data</h2>
            <div className="info-list">
              {pokemon.pokedexData.map((item, index) => (
                <div className="info-row" key={index}>
                  <span className="info-label">{item.label}</span>
                  <span className="info-value">{item.value}</span>
                </div>
              ))}
            </div>
          </div>

          <div className="card">
            <h2 className="section-title">Training</h2>
            <div className="info-list">
              {pokemon.training.map((item, index) => (
                <div className="info-row" key={index}>
                  <span className="info-label">{item.label}</span>
                  <span className="info-value">{item.value}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="card">
          <h2 className="section-title">Base Stats</h2>
          <div className="stats-list">
            {pokemon.stats.map((stat) => (
              <div className="stat-row" key={stat.label}>
                <span className="stat-name">{stat.label}</span>
                <span className="stat-number">{stat.value}</span>
                <div className="stat-bar-track">
                  <div
                    className="stat-bar-fill"
                    style={{ width: `${(stat.value / stat.max) * 100}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </section>

        <section className="card">
          <h2 className="section-title">Evolution Chart</h2>
          <div className="evolution-chart">
            {pokemon.evolutions.map((evo, index) => (
              <React.Fragment key={evo.id}>
                <div className="evolution-item">
                  <img
                    src={evo.image}
                    alt={evo.name}
                    className="evolution-image"
                  />
                  <h3 className="evolution-name">{evo.name}</h3>
                  <p className="evolution-stage">
                    {index === 0 ? "Base Form" : "Evolution"}
                  </p>
                </div>

                {index < pokemon.evolutions.length - 1 && (
                  <div className="evolution-arrow-block">
                    <span className="evolution-arrow">→</span>
                    <small className="evolution-level">
                      {pokemon.evolutions[index + 1].level || ""}
                    </small>
                  </div>
                )}
              </React.Fragment>
            ))}
          </div>
        </section>

        <section className="card">
          <h2 className="section-title">Pokédex Entries</h2>
          <div className="entries-list">
            {pokemon.entries.map((entry, index) => (
              <div className="entry-row" key={index}>
                <div className="entry-version">{entry.version}</div>
                <div className="entry-text">{entry.text}</div>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
};

export default PokemonDetailsPage;