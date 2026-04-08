import React, { useEffect, useMemo, useState } from "react";
import "../Style/pokemon-modern-table.css";

type Pokemon = {
  id: number;
  name: string;
  category: string;
  height: number;
  weight: number;
  catch_rate: number;
  base_exp: number;
  growth_rate: string;
  habitat: string;
  g_ratio: number;
};

type SortKey =
  | "id"
  | "name"
  | "category"
  | "height"
  | "weight"
  | "catch_rate"
  | "base_exp"
  | "growth_rate"
  | "habitat"
  | "g_ratio";

type SortDirection = "asc" | "desc";

const GROWTH_RATES = ["Fast", "Medium Fast", "Medium Slow", "Slow"];

const HABITATS = [
  "Cave",
  "Forest",
  "Grassland",
  "Mountain",
  "Rare",
  "Rough-terrain",
  "Sea",
  "Urban",
  "Water's-edge",
];

const DEFAULT_MIN_MAX = {
  heightMin: 0.2,
  heightMax: 8.8,
  weightMin: 0.1,
  weightMax: 460.0,
  catchRateMin: 3,
  catchRateMax: 255,
  baseExpMin: 39,
  baseExpMax: 395,
  gRatioMin: -1,
  gRatioMax: 8,
};

const getPokemonImage = (id: number) =>
  `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${id}.png`;

const getPokemonLink = (id: number) => `https://www.pokemon.com/us/pokedex/${id}`;

const formatDexId = (id: number) => String(id).padStart(3, "0");

const genderRatioLabel = (value: number) => {
  if (value === -1) return "Genderless";
  if (value === 0) return "Male only";
  if (value === 8) return "Female only";
  return `${value}/8 ♀`;
};

export default function PokemonModernTable() {
  const [pokemon, setPokemon] = useState<Pokemon[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [nameQuery, setNameQuery] = useState("");
  const [categoryQuery, setCategoryQuery] = useState("");

  const [selectedGrowthRates, setSelectedGrowthRates] = useState<string[]>([]);
  const [selectedHabitats, setSelectedHabitats] = useState<string[]>([]);

  const [heightMin, setHeightMin] = useState<number>(DEFAULT_MIN_MAX.heightMin);
  const [heightMax, setHeightMax] = useState<number>(DEFAULT_MIN_MAX.heightMax);

  const [weightMin, setWeightMin] = useState<number>(DEFAULT_MIN_MAX.weightMin);
  const [weightMax, setWeightMax] = useState<number>(DEFAULT_MIN_MAX.weightMax);

  const [catchRateMin, setCatchRateMin] = useState<number>(DEFAULT_MIN_MAX.catchRateMin);
  const [catchRateMax, setCatchRateMax] = useState<number>(DEFAULT_MIN_MAX.catchRateMax);

  const [baseExpMin, setBaseExpMin] = useState<number>(DEFAULT_MIN_MAX.baseExpMin);
  const [baseExpMax, setBaseExpMax] = useState<number>(DEFAULT_MIN_MAX.baseExpMax);

  const [gRatioMin, setGRatioMin] = useState<number>(DEFAULT_MIN_MAX.gRatioMin);
  const [gRatioMax, setGRatioMax] = useState<number>(DEFAULT_MIN_MAX.gRatioMax);

  const [sortKey, setSortKey] = useState<SortKey>("id");
  const [sortDirection, setSortDirection] = useState<SortDirection>("asc");

  useEffect(() => {
    const loadPokemon = async () => {
      try {
        setLoading(true);
        setError("");

        // Change this URL to your Laravel / PHP backend endpoint
        // Example: http://127.0.0.1:8000/api/pokemon
        const res = await fetch("http://127.0.0.1:8000/api/pokemon", {
          headers: {
            Accept: "application/json",
          },
        });

        if (!res.ok) {
          throw new Error(`Failed to load Pokémon data. Status: ${res.status}`);
        }

        const data = await res.json();

        // Support either direct array OR { data: [...] }
        const rows: Pokemon[] = Array.isArray(data) ? data : data.data ?? [];

        setPokemon(rows);
      } catch (err) {
        console.error(err);
        setError("Could not load Pokémon data. Check backend route / CORS / JSON format.");
      } finally {
        setLoading(false);
      }
    };

    loadPokemon();
  }, []);

  const toggleFromList = (
    value: string,
    current: string[],
    setter: React.Dispatch<React.SetStateAction<string[]>>
  ) => {
    if (current.includes(value)) {
      setter(current.filter((item) => item !== value));
    } else {
      setter([...current, value]);
    }
  };

  const resetFilters = () => {
    setNameQuery("");
    setCategoryQuery("");
    setSelectedGrowthRates([]);
    setSelectedHabitats([]);

    setHeightMin(DEFAULT_MIN_MAX.heightMin);
    setHeightMax(DEFAULT_MIN_MAX.heightMax);

    setWeightMin(DEFAULT_MIN_MAX.weightMin);
    setWeightMax(DEFAULT_MIN_MAX.weightMax);

    setCatchRateMin(DEFAULT_MIN_MAX.catchRateMin);
    setCatchRateMax(DEFAULT_MIN_MAX.catchRateMax);

    setBaseExpMin(DEFAULT_MIN_MAX.baseExpMin);
    setBaseExpMax(DEFAULT_MIN_MAX.baseExpMax);

    setGRatioMin(DEFAULT_MIN_MAX.gRatioMin);
    setGRatioMax(DEFAULT_MIN_MAX.gRatioMax);

    setSortKey("id");
    setSortDirection("asc");
  };

  const filteredPokemon = useMemo(() => {
    let rows = [...pokemon];

    rows = rows.filter((p) =>
      p.name.toLowerCase().includes(nameQuery.trim().toLowerCase())
    );

    rows = rows.filter((p) =>
      p.category.toLowerCase().includes(categoryQuery.trim().toLowerCase())
    );

    if (selectedGrowthRates.length > 0) {
      rows = rows.filter((p) => selectedGrowthRates.includes(p.growth_rate));
    }

    if (selectedHabitats.length > 0) {
      rows = rows.filter((p) => selectedHabitats.includes(p.habitat));
    }

    rows = rows.filter(
      (p) =>
        p.height >= heightMin &&
        p.height <= heightMax &&
        p.weight >= weightMin &&
        p.weight <= weightMax &&
        p.catch_rate >= catchRateMin &&
        p.catch_rate <= catchRateMax &&
        p.base_exp >= baseExpMin &&
        p.base_exp <= baseExpMax &&
        p.g_ratio >= gRatioMin &&
        p.g_ratio <= gRatioMax
    );

    rows.sort((a, b) => {
      const dir = sortDirection === "asc" ? 1 : -1;
      const av = a[sortKey];
      const bv = b[sortKey];

      if (typeof av === "number" && typeof bv === "number") {
        return (av - bv) * dir;
      }

      return String(av).localeCompare(String(bv)) * dir;
    });

    return rows;
  }, [
    pokemon,
    nameQuery,
    categoryQuery,
    selectedGrowthRates,
    selectedHabitats,
    heightMin,
    heightMax,
    weightMin,
    weightMax,
    catchRateMin,
    catchRateMax,
    baseExpMin,
    baseExpMax,
    gRatioMin,
    gRatioMax,
    sortKey,
    sortDirection,
  ]);

  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortDirection((prev) => (prev === "asc" ? "desc" : "asc"));
      return;
    }

    setSortKey(key);
    setSortDirection("asc");
  };

  const sortIndicator = (key: SortKey) => {
    if (sortKey !== key) return "↕";
    return sortDirection === "asc" ? "↑" : "↓";
  };

  return (
    <div className="pokemon-page">
      <div className="pokemon-shell">
        <header className="pokemon-hero">
          <div>
            <p className="pokemon-badge">Gen 1 Dashboard</p>
            <h1>Pokédex Explorer</h1>
            <p className="pokemon-subtitle">
              151 Pokémon with searchable filters, spinboxes, image links, and modern table layout.
            </p>
          </div>

          <div className="hero-stats">
            <div className="hero-stat-card">
              <span className="hero-stat-label">Total Loaded</span>
              <strong>{pokemon.length}</strong>
            </div>
            <div className="hero-stat-card">
              <span className="hero-stat-label">Showing</span>
              <strong>{filteredPokemon.length}</strong>
            </div>
          </div>
        </header>

        <section className="filters-card">
          <div className="filters-top">
            <h2>Filters</h2>
            <button className="reset-btn" onClick={resetFilters}>
              Reset All
            </button>
          </div>

          <div className="filters-grid">
            <div className="filter-block">
              <label>Name</label>
              <input
                type="text"
                placeholder="Search by Pokémon name"
                value={nameQuery}
                onChange={(e) => setNameQuery(e.target.value)}
              />
            </div>

            <div className="filter-block">
              <label>Category</label>
              <input
                type="text"
                placeholder="Search category"
                value={categoryQuery}
                onChange={(e) => setCategoryQuery(e.target.value)}
              />
            </div>

            <div className="filter-block">
              <label>Catch Rate</label>
              <div className="range-row">
                <input
                  type="number"
                  value={catchRateMin}
                  min={3}
                  max={255}
                  onChange={(e) => setCatchRateMin(Number(e.target.value))}
                />
                <span>to</span>
                <input
                  type="number"
                  value={catchRateMax}
                  min={3}
                  max={255}
                  onChange={(e) => setCatchRateMax(Number(e.target.value))}
                />
              </div>
            </div>

            <div className="filter-block">
              <label>Height (m)</label>
              <div className="range-row">
                <input
                  type="number"
                  step="0.1"
                  value={heightMin}
                  onChange={(e) => setHeightMin(Number(e.target.value))}
                />
                <span>to</span>
                <input
                  type="number"
                  step="0.1"
                  value={heightMax}
                  onChange={(e) => setHeightMax(Number(e.target.value))}
                />
              </div>
            </div>

            <div className="filter-block">
              <label>Weight (kg)</label>
              <div className="range-row">
                <input
                  type="number"
                  step="0.1"
                  value={weightMin}
                  onChange={(e) => setWeightMin(Number(e.target.value))}
                />
                <span>to</span>
                <input
                  type="number"
                  step="0.1"
                  value={weightMax}
                  onChange={(e) => setWeightMax(Number(e.target.value))}
                />
              </div>
            </div>

            <div className="filter-block">
              <label>Base Exp</label>
              <div className="range-row">
                <input
                  type="number"
                  value={baseExpMin}
                  onChange={(e) => setBaseExpMin(Number(e.target.value))}
                />
                <span>to</span>
                <input
                  type="number"
                  value={baseExpMax}
                  onChange={(e) => setBaseExpMax(Number(e.target.value))}
                />
              </div>
            </div>

            <div className="filter-block">
              <label>Gender Ratio (g_ratio)</label>
              <div className="range-row">
                <input
                  type="number"
                  value={gRatioMin}
                  min={-1}
                  max={8}
                  onChange={(e) => setGRatioMin(Number(e.target.value))}
                />
                <span>to</span>
                <input
                  type="number"
                  value={gRatioMax}
                  min={-1}
                  max={8}
                  onChange={(e) => setGRatioMax(Number(e.target.value))}
                />
              </div>
            </div>
          </div>

          <div className="checkbox-sections">
            <div className="checkbox-card">
              <h3>Growth Rate</h3>
              <div className="checkbox-list">
                {GROWTH_RATES.map((item) => (
                  <label key={item} className="check-pill">
                    <input
                      type="checkbox"
                      checked={selectedGrowthRates.includes(item)}
                      onChange={() =>
                        toggleFromList(item, selectedGrowthRates, setSelectedGrowthRates)
                      }
                    />
                    <span>{item}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="checkbox-card">
              <h3>Habitat</h3>
              <div className="checkbox-list">
                {HABITATS.map((item) => (
                  <label key={item} className="check-pill">
                    <input
                      type="checkbox"
                      checked={selectedHabitats.includes(item)}
                      onChange={() =>
                        toggleFromList(item, selectedHabitats, setSelectedHabitats)
                      }
                    />
                    <span>{item}</span>
                  </label>
                ))}
              </div>
            </div>
          </div>
        </section>

        <section className="table-card">
          {loading && <div className="state-box">Loading Pokémon data...</div>}
          {error && !loading && <div className="state-box error">{error}</div>}

          {!loading && !error && (
            <div className="table-wrap">
              <table className="pokemon-table">
                <thead>
                  <tr>
                    <th onClick={() => handleSort("id")}>ID {sortIndicator("id")}</th>
                    <th>Image</th>
                    <th onClick={() => handleSort("name")}>Name {sortIndicator("name")}</th>
                    <th onClick={() => handleSort("category")}>
                      Category {sortIndicator("category")}
                    </th>
                    <th onClick={() => handleSort("height")}>
                      Height {sortIndicator("height")}
                    </th>
                    <th onClick={() => handleSort("weight")}>
                      Weight {sortIndicator("weight")}
                    </th>
                    <th onClick={() => handleSort("catch_rate")}>
                      Catch Rate {sortIndicator("catch_rate")}
                    </th>
                    <th onClick={() => handleSort("base_exp")}>
                      Base Exp {sortIndicator("base_exp")}
                    </th>
                    <th onClick={() => handleSort("growth_rate")}>
                      Growth Rate {sortIndicator("growth_rate")}
                    </th>
                    <th onClick={() => handleSort("habitat")}>
                      Habitat {sortIndicator("habitat")}
                    </th>
                    <th onClick={() => handleSort("g_ratio")}>
                      G Ratio {sortIndicator("g_ratio")}
                    </th>
                  </tr>
                </thead>

                <tbody>
                  {filteredPokemon.map((p) => (
                    <tr key={p.id}>
                      <td className="mono">{formatDexId(p.id)}</td>

                      <td>
                        <a
                          href={getPokemonLink(p.id)}
                          target="_blank"
                          rel="noreferrer"
                          className="img-link"
                          title={`Open ${p.name}`}
                        >
                          <img
                            src={getPokemonImage(p.id)}
                            alt={p.name}
                            className="pokemon-thumb"
                            loading="lazy"
                          />
                        </a>
                      </td>

                      <td>
                        <div className="name-cell">
                          <a
                            href={getPokemonLink(p.id)}
                            target="_blank"
                            rel="noreferrer"
                            className="name-link"
                          >
                            {p.name}
                          </a>
                        </div>
                      </td>

                      <td>{p.category}</td>
                      <td>{p.height.toFixed(1)} m</td>
                      <td>{p.weight.toFixed(1)} kg</td>
                      <td>{p.catch_rate}</td>
                      <td>{p.base_exp}</td>
                      <td>
                        <span className="tag growth">{p.growth_rate}</span>
                      </td>
                      <td>
                        <span className="tag habitat">{p.habitat}</span>
                      </td>
                      <td title={genderRatioLabel(p.g_ratio)}>{p.g_ratio}</td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {filteredPokemon.length === 0 && (
                <div className="empty-box">No Pokémon matched your filters.</div>
              )}
            </div>
          )}
        </section>
      </div>
    </div>
  );
}