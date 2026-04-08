import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
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
  theme: ThemeType;
  pokedexData: InfoItem[];
  training: InfoItem[];
  stats: Stat[];
  evolutions: EvolutionStage[];
  entries: PokedexEntry[];
};

const PokemonDetailsPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();

  const [pokemon, setPokemon] = useState<PokemonType | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>("");

  useEffect(() => {
    const loadPokemon = async () => {
      try {
        setLoading(true);
        setError("");

        if (!id) {
          throw new Error("Pokemon ID not found in route");
        }

        const response = await fetch(`http://127.0.0.1:8000/api/pokemon/${id}`, {
          method: "GET",
          headers: {
            Accept: "application/json",
          },
        });

        const rawText = await response.text();
        console.log("HTTP status:", response.status);
        console.log("Raw response:", rawText);

        if (!response.ok) {
          throw new Error(`Backend error ${response.status}: ${rawText}`);
        }

        const data: PokemonType = JSON.parse(rawText);
        setPokemon(data);
      } catch (err) {
        console.error("Fetch error:", err);
        setError(err instanceof Error ? err.message : "Could not load pokemon data");
      } finally {
        setLoading(false);
      }
    };

    loadPokemon();
  }, [id]);

  if (loading) {
    return <div className="pokemon-loading">Loading...</div>;
  }

  if (error || !pokemon) {
    return <div className="pokemon-error">{error || "No data found"}</div>;
  }

  const themeStyle = {
    "--body-bg": pokemon.theme.bodyBackground,
    "--accent": pokemon.theme.accent,
    "--accent-soft": pokemon.theme.accentSoft,
    "--secondary": pokemon.theme.secondary,
    "--title-color": pokemon.theme.titleColor,
    "--text-color": pokemon.theme.textColor,
    "--card-bg": pokemon.theme.cardBackground,
    "--hover-shadow": pokemon.theme.hoverShadow,
    "--stat-number-color": pokemon.theme.statNumberColor,
    "--stat-bar-gradient": pokemon.theme.statBarGradient,
    "--section-line-gradient": pokemon.theme.sectionLineGradient,
    "--entry-version-color": pokemon.theme.entryVersionColor,
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