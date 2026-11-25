import 'package:material_ui/material_ui.dart';
import '../models/book.dart';

/// Helper to build structured sample chapters for each book.
List<BookChapter> _buildChapters({
  required String title,
  required String author,
  required String c1Title,
  required String c1Body,
  required String c2Title,
  required String c2Body,
  required String c3Title,
  required String c3Body,
}) {
  return [
    BookChapter(
      title: 'Chapter 1: $c1Title',
      content: '$c1Body\n\n'
          'In this opening section of "$title", $author sets the foundation for the ideas and scenes that follow. '
          'Every detail—from the pacing of the prose to the quiet observations in the margins—invites the reader to slow down and engage thoughtfully.\n\n'
          'As you move through these sample pages, notice how the central question emerges naturally from everyday observation rather than grand abstraction.',
    ),
    BookChapter(
      title: 'Chapter 2: $c2Title',
      content: '$c2Body\n\n'
          'Building on the opening chapter, this passage deepens the core theme with concrete examples and sharper contrast. '
          'What initially seemed straightforward reveals subtle tensions beneath the surface.\n\n'
          'Readers often return to this chapter when reflecting on how small shifts in perspective reshape the entire landscape of a problem.',
    ),
    BookChapter(
      title: 'Chapter 3: $c3Title',
      content: '$c3Body\n\n'
          'In the concluding sample chapter, the threads introduced earlier begin to converge. '
          'Rather than offering a hurried summary, $author leaves room for reflection and practical application.\n\n'
          'You have reached the end of the BookNest sample edition for "$title". Mark this book as completed in your library or revisit earlier chapters anytime.',
    ),
  ];
}

/// Curated catalog of 28 sample books across all 11 categories.
final List<Book> kBooks = [
  Book(
    id: 'bk-01',
    title: 'The Quiet Cartographer',
    author: 'Elena Vance',
    description:
        'An atmospheric literary novel about an archivist who discovers an uncharted coastal town hidden inside nineteenth-century maritime ledgers.',
    category: 'Fiction',
    rating: 4.9,
    pageCount: 342,
    publicationYear: 2024,
    popularityScore: 98,
    isFeatured: true,
    isPopular: true,
    isTrending: true,
    coverColor: const Color(0xFF16243B),
    coverAccentColor: const Color(0xFFD97724),
    coverPattern: CoverPattern.archway,
    chapters: _buildChapters(
      title: 'The Quiet Cartographer',
      author: 'Elena Vance',
      c1Title: 'The Salt-Stained Ledger',
      c1Body:
          'Rain tapped against the tall casement windows of the Maritime Archive as Clara unfastened the brass clasp of Ledger No. 412. Between tide tables for Bergen and Lisbon lay a folded sheet of vellum inked in fading sepia.',
      c2Title: 'Soundings at Low Tide',
      c2Body:
          'Three days later, the coastal ferry dropped anchor outside a harbor that appeared on no modern chart. Stone breakwaters curved like a crescent moon around rooftops slick with morning mist.',
      c3Title: 'Lines Drawn in Water',
      c3Body:
          'Maps, Clara realized, were never mere records of rock and shoal; they were promises made by travelers who hoped someone else might follow safely.',
    ),
  ),
  Book(
    id: 'bk-02',
    title: 'Letters from the Cedar House',
    author: 'Haruto Sato',
    description:
        'Across four seasons in a mountain woodworking studio, two estranged siblings rebuild their bond through handwritten notes and shared craft.',
    category: 'Fiction',
    rating: 4.7,
    pageCount: 276,
    publicationYear: 2023,
    popularityScore: 86,
    isPopular: true,
    coverColor: const Color(0xFF3E2723),
    coverAccentColor: const Color(0xFFE9C46A),
    coverPattern: CoverPattern.horizonBand,
    chapters: _buildChapters(
      title: 'Letters from the Cedar House',
      author: 'Haruto Sato',
      c1Title: 'Shavings on the Floor',
      c1Body:
          'The cedar plane sang a thin, dry note as Kenji drew it along the grain. On the workbench sat an unopened envelope postmarked from Kyoto.',
      c2Title: 'Autumn Joinery',
      c2Body:
          'A mortise-and-tenon joint requires patience before force; push too early and the timber splits, wait too long and the season turns.',
      c3Title: 'Winter Light',
      c3Body:
          'By January, the workshop smelled of fresh resin and roasted tea, and the silence between them had become companionable.',
    ),
  ),
  Book(
    id: 'bk-03',
    title: 'Glass Harbor',
    author: 'Miriam Al-Mansoor',
    description:
        'A sweeping family chronicle set in a sunlit Mediterranean port where glassmakers, sailors, and poets cross paths over half a century.',
    category: 'Fiction',
    rating: 4.6,
    pageCount: 410,
    publicationYear: 2022,
    popularityScore: 79,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF1D4E5F),
    coverAccentColor: const Color(0xFFF4A261),
    coverPattern: CoverPattern.editorialGrid,
    chapters: _buildChapters(
      title: 'Glass Harbor',
      author: 'Miriam Al-Mansoor',
      c1Title: 'The Kiln at Dawn',
      c1Body:
          'Before the market bells rang, the glassworks glowed amber against the harbor fog, turning silica and sea-kelp ash into translucent bowls.',
      c2Title: 'The Merchant Vessel',
      c2Body:
          'Every crate packed in straw carried a piece of the city across the sea, stamped with the twin-wave seal of the guild.',
      c3Title: 'Reflections',
      c3Body:
          'Decades later, the granddaughters stood on the same quay and recognized the tint of cobalt glass in the museum window.',
    ),
  ),
  Book(
    id: 'bk-04',
    title: 'Orbital Meridian',
    author: 'Dr. Marcus Chen',
    description:
        'When a solar-sail relay near Saturn goes silent, a two-person maintenance crew uncovers an unexpected signal from the outer Kuiper Belt.',
    category: 'Science Fiction',
    rating: 4.8,
    pageCount: 388,
    publicationYear: 2025,
    popularityScore: 95,
    isTrending: true,
    isPopular: true,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF14213D),
    coverAccentColor: const Color(0xFF56CFE1),
    coverPattern: CoverPattern.orbitalRings,
    chapters: _buildChapters(
      title: 'Orbital Meridian',
      author: 'Dr. Marcus Chen',
      c1Title: 'Telemetry Drift',
      c1Body:
          'At 9.5 astronomical units, sunlight arrives as a pale silver coin. Commander Reyes watched the attitude thruster logs scroll in crisp emerald across her visor.',
      c2Title: 'Shadow of Enceladus',
      c2Body:
          'The relay dish was intact, its gold foil unblemished—yet its optical buffer held forty gigabytes of structured harmonic pulses.',
      c3Title: 'Beyond the Heliopause',
      c3Body:
          'Whatever had transmitted the pattern was not asking for rescue; it was marking a beacon for travelers yet to leave Earth.',
    ),
  ),
  Book(
    id: 'bk-05',
    title: 'Children of the Red Dust',
    author: 'Nadia Okafor',
    description:
        'Three generations of botanists and engineers transform a Martian lava tube into a thriving subterranean biosphere.',
    category: 'Science Fiction',
    rating: 4.7,
    pageCount: 364,
    publicationYear: 2024,
    popularityScore: 88,
    isTrending: true,
    coverColor: const Color(0xFF5E2B25),
    coverAccentColor: const Color(0xFFF6BD60),
    coverPattern: CoverPattern.diagonalSplit,
    chapters: _buildChapters(
      title: 'Children of the Red Dust',
      author: 'Nadia Okafor',
      c1Title: 'Basalt Vaults',
      c1Body:
          'Sixty meters beneath Tharsis Rise, the temperature never swung by more than two degrees. Here, moss could finally learn to breathe.',
      c2Title: 'Hydroponic Rain',
      c2Body:
          'The first condensation droplets on the polycarbonate dome drew cheers louder than any rocket ignition.',
      c3Title: 'First Harvest',
      c3Body:
          'To grow wheat in regolith was to sign a peace treaty with another world.',
    ),
  ),
  Book(
    id: 'bk-06',
    title: 'The Clockwork Lattice',
    author: 'Julian Mercer',
    description:
        'In a city powered by mechanical prediction engines, a young apprentice discovers how to introduce deliberate uncertainty.',
    category: 'Science Fiction',
    rating: 4.5,
    pageCount: 312,
    publicationYear: 2021,
    popularityScore: 76,
    coverColor: const Color(0xFF2B2D42),
    coverAccentColor: const Color(0xFF8D99AE),
    coverPattern: CoverPattern.editorialGrid,
    chapters: _buildChapters(
      title: 'The Clockwork Lattice',
      author: 'Julian Mercer',
      c1Title: 'Brass and Balance',
      c1Body:
          'Every morning at six, the Grand Regulator chimed the exact rainfall expected in each ward.',
      c2Title: 'The Missing Gear',
      c2Body:
          'A single tooth filed by half a millimeter turned a deterministic march into an open-ended improvisation.',
      c3Title: 'Unscripted Skies',
      c3Body:
          'For the first time in a century, citizens looked up at the clouds without checking their pocket almanacs.',
    ),
  ),
  Book(
    id: 'bk-07',
    title: 'Designing Resilient Systems',
    author: 'Sonia Patel',
    description:
        'A clear-eyed guide to distributed reliability, graceful degradation, and building technology that remains humane under pressure.',
    category: 'Technology',
    rating: 4.9,
    pageCount: 298,
    publicationYear: 2025,
    popularityScore: 94,
    isPopular: true,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF1B4332),
    coverAccentColor: const Color(0xFF74C69D),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'Designing Resilient Systems',
      author: 'Sonia Patel',
      c1Title: 'Failure as Normal State',
      c1Body:
          'Every sufficiently complex system operates in partial failure most of the time. Resilience begins the moment we stop pretending hardware and networks are infallible.',
      c2Title: 'Backpressure and Boundaries',
      c2Body:
          'A well-placed queue or circuit breaker protects the whole city by letting one district dim its lights gracefully.',
      c3Title: 'Observability for Humans',
      c3Body:
          'Dashboards should answer questions during an incident, not decorate a wall during calm weather.',
    ),
  ),
  Book(
    id: 'bk-08',
    title: 'The Silicon Loom',
    author: 'Arthur Pendelton',
    description:
        'From Jacquard punch cards to modern neural accelerators, trace how weaving logic into matter transformed human civilization.',
    category: 'Technology',
    rating: 4.6,
    pageCount: 356,
    publicationYear: 2023,
    popularityScore: 81,
    coverColor: const Color(0xFF264653),
    coverAccentColor: const Color(0xFFE9C46A),
    coverPattern: CoverPattern.editorialGrid,
    chapters: _buildChapters(
      title: 'The Silicon Loom',
      author: 'Arthur Pendelton',
      c1Title: 'Threads of Logic',
      c1Body:
          'In 1804, a pattern card did not merely decorate silk; it proved that instructions could be separated from the machine itself.',
      c2Title: 'Transistor Cities',
      c2Body:
          'Shrinking switches to nanometers turned room-sized calculators into pocket companions.',
      c3Title: 'The Next Fabric',
      c3Body:
          'Every generation rewrites the boundary between tool and collaborator.',
    ),
  ),
  Book(
    id: 'bk-09',
    title: 'Clean Dart & Flutter Craft',
    author: 'Lucas Meyer',
    description:
        'Practical patterns for modular state management, responsive adaptive UI, and maintainable Flutter applications at scale.',
    category: 'Programming',
    rating: 4.9,
    pageCount: 324,
    publicationYear: 2025,
    popularityScore: 96,
    isTrending: true,
    isPopular: true,
    coverColor: const Color(0xFF16243B),
    coverAccentColor: const Color(0xFF4CC9F0),
    coverPattern: CoverPattern.diagonalSplit,
    chapters: _buildChapters(
      title: 'Clean Dart & Flutter Craft',
      author: 'Lucas Meyer',
      c1Title: 'Composition Over Inheritance',
      c1Body:
          'Flutter rewards small, focused widgets whose contracts are obvious at a glance. When a build method grows past a screenful, it is asking to be split.',
      c2Title: 'State That Scales',
      c2Body:
          'Separate ephemeral UI state from domain state, and let providers expose clear, testable operations rather than raw mutable maps.',
      c3Title: 'Responsive by Default',
      c3Body:
          'Design for fluid breakpoints so desktop sidebars and mobile bottom bars share the same underlying navigation model.',
    ),
  ),
  Book(
    id: 'bk-10',
    title: 'Algorithms in Plain Sight',
    author: 'Priya Nair',
    description:
        'An intuitive, visual journey through graphs, dynamic programming, and spatial indexing without intimidating notation.',
    category: 'Programming',
    rating: 4.8,
    pageCount: 288,
    publicationYear: 2024,
    popularityScore: 89,
    isPopular: true,
    coverColor: const Color(0xFF2B2D42),
    coverAccentColor: const Color(0xFFF4A261),
    coverPattern: CoverPattern.orbitalRings,
    chapters: _buildChapters(
      title: 'Algorithms in Plain Sight',
      author: 'Priya Nair',
      c1Title: 'Searching a Library',
      c1Body:
          'Binary search is not a trick for coding interviews—it is how you naturally open a dictionary near the middle.',
      c2Title: 'Shortest Paths',
      c2Body:
          'When weights represent time or effort, exploring the cheapest frontier first guarantees you never waste steps.',
      c3Title: 'Trade-offs in Memory',
      c3Body:
          'Every fast lookup is a bet that space spent today will save time tomorrow.',
    ),
  ),
  Book(
    id: 'bk-11',
    title: 'The Pragmatic Refactor',
    author: 'Owen Gallagher',
    description:
        'How to evolve legacy codebases safely with characterization tests, small commits, and clear architectural seams.',
    category: 'Programming',
    rating: 4.6,
    pageCount: 244,
    publicationYear: 2022,
    popularityScore: 78,
    coverColor: const Color(0xFF333D29),
    coverAccentColor: const Color(0xFFC2C5AA),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'The Pragmatic Refactor',
      author: 'Owen Gallagher',
      c1Title: 'Reading Before Rewriting',
      c1Body:
          'The urge to rewrite from scratch usually fades once we understand why the messy edge cases were added in the first place.',
      c2Title: 'Seams and Adapters',
      c2Body:
          'Wrap external dependencies behind narrow interfaces so tests run in milliseconds.',
      c3Title: 'Steady Momentum',
      c3Body:
          'Leave every file slightly clearer than you found it, and technical debt shrinks week by week.',
    ),
  ),
  Book(
    id: 'bk-12',
    title: 'Calm Strategy',
    author: 'Claire Beaumont',
    description:
        'Why enduring companies choose focus, craft, and sustainable margins over frantic growth-at-all-costs.',
    category: 'Business',
    rating: 4.7,
    pageCount: 260,
    publicationYear: 2024,
    popularityScore: 85,
    isTrending: true,
    coverColor: const Color(0xFF4A2545),
    coverAccentColor: const Color(0xFFE9C46A),
    coverPattern: CoverPattern.horizonBand,
    chapters: _buildChapters(
      title: 'Calm Strategy',
      author: 'Claire Beaumont',
      c1Title: 'The Noise Penalty',
      c1Body:
          'Organizations rarely fail from a shortage of ideas; they stall because too many unaligned priorities compete for the same Tuesday.',
      c2Title: 'Pricing with Clarity',
      c2Body:
          'Value-based pricing forces you to articulate the exact problem you solve for the customer.',
      c3Title: 'Long-Horizon Teams',
      c3Body:
          'Trust compounds when teams stay together long enough to see their decisions mature.',
    ),
  ),
  Book(
    id: 'bk-13',
    title: 'Product Sense & Craft',
    author: 'David Kim',
    description:
        'Field notes on user research, crisp product specs, and shipping digital tools people genuinely enjoy using.',
    category: 'Business',
    rating: 4.8,
    pageCount: 274,
    publicationYear: 2025,
    popularityScore: 91,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF1F3A5F),
    coverAccentColor: const Color(0xFFE07A5F),
    coverPattern: CoverPattern.archway,
    chapters: _buildChapters(
      title: 'Product Sense & Craft',
      author: 'David Kim',
      c1Title: 'Listening Past Feature Requests',
      c1Body:
          'When a user asks for an export button, they may actually be asking for confidence that their work is safe.',
      c2Title: 'The First Five Minutes',
      c2Body:
          'Onboarding is not a slideshow; it is the moment your product proves it respects the user’s time.',
      c3Title: 'Sweating the Edges',
      c3Body:
          'Empty states, keyboard shortcuts, and clear error messages are where good software becomes memorable.',
    ),
  ),
  Book(
    id: 'bk-14',
    title: 'Empires of Paper & Ink',
    author: 'Prof. Alistair Finch',
    description:
        'A vivid history of how printing presses, postal routes, and public libraries democratized knowledge across continents.',
    category: 'History',
    rating: 4.8,
    pageCount: 430,
    publicationYear: 2023,
    popularityScore: 87,
    isPopular: true,
    coverColor: const Color(0xFF5C3A21),
    coverAccentColor: const Color(0xFFDDA15E),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'Empires of Paper & Ink',
      author: 'Prof. Alistair Finch',
      c1Title: 'Rag Paper and Movable Type',
      c1Body:
          'Before a single book could be bound, linen rags had to be washed, beaten into pulp, and dried on brass wire screens.',
      c2Title: 'The Reading Room',
      c2Body:
          'Municipal libraries turned solitary scholarship into a shared civic right open to any apprentice with an evening free.',
      c3Title: 'Living Archives',
      c3Body:
          'Every generation invents a new medium, yet the core impulse remains: to preserve thought across time.',
    ),
  ),
  Book(
    id: 'bk-15',
    title: 'Roads of Spice and Silk',
    author: 'Leila Farrokh',
    description:
        'Stories of oasis cities, astronomical tables, and cultural exchange along the ancient Eurasian trade corridors.',
    category: 'History',
    rating: 4.6,
    pageCount: 392,
    publicationYear: 2022,
    popularityScore: 77,
    coverColor: const Color(0xFF6B2D26),
    coverAccentColor: const Color(0xFFE9C46A),
    coverPattern: CoverPattern.archway,
    chapters: _buildChapters(
      title: 'Roads of Spice and Silk',
      author: 'Leila Farrokh',
      c1Title: 'Caravanserai Nights',
      c1Body:
          'Behind thick mud-brick walls, merchants from Samarkand and Antioch traded saffron, paper recipes, and star charts.',
      c2Title: 'The Astrolabe Makers',
      c2Body:
          'Precision brass instruments allowed travelers to read latitude from the night sky with astonishing accuracy.',
      c3Title: 'Echoes in Language',
      c3Body:
          'Even today, our words for sugar, zero, and crimson trace those overland journeys.',
    ),
  ),
  Book(
    id: 'bk-16',
    title: 'The Lighthouse Keeper’s Daughter',
    author: 'Hannah Lindqvist',
    description:
        'An intimate biography of a nineteenth-century coastal meteorologist whose storm logs saved hundreds of ships.',
    category: 'Biography',
    rating: 4.7,
    pageCount: 304,
    publicationYear: 2024,
    popularityScore: 84,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF3D405B),
    coverAccentColor: const Color(0xFFE07A5F),
    coverPattern: CoverPattern.horizonBand,
    chapters: _buildChapters(
      title: 'The Lighthouse Keeper’s Daughter',
      author: 'Hannah Lindqvist',
      c1Title: 'Barometer at Midnight',
      c1Body:
          'At fourteen, Astrid learned to read mercury columns and cloud anvils before she ever stepped onto a mainland street.',
      c2Title: 'Telegraph on the Cliff',
      c2Body:
          'Her early-warning dispatches gave fishing fleets six crucial hours to reach shelter.',
      c3Title: 'A Quiet Legacy',
      c3Body:
          'Her handwritten notebooks still anchor modern North Sea climate reconstructions.',
    ),
  ),
  Book(
    id: 'bk-17',
    title: 'Ada’s Analytical Engine',
    author: 'Rebecca Sterling',
    description:
        'A portrait of Ada Lovelace, her mathematical imagination, and her vision of computing beyond mere arithmetic.',
    category: 'Biography',
    rating: 4.9,
    pageCount: 318,
    publicationYear: 2023,
    popularityScore: 92,
    isPopular: true,
    coverColor: const Color(0xFF283655),
    coverAccentColor: const Color(0xFFF6BD60),
    coverPattern: CoverPattern.orbitalRings,
    chapters: _buildChapters(
      title: 'Ada’s Analytical Engine',
      author: 'Rebecca Sterling',
      c1Title: 'Poetical Science',
      c1Body:
          'Raised between strict tutors and romantic verse, Ada saw no contradiction between imagination and rigorous proof.',
      c2Title: 'Note G',
      c2Body:
          'In her famous table for Bernoulli numbers, she sketched loops, variables, and symbolic manipulation.',
      c3Title: 'Weaving Music',
      c3Body:
          'She foresaw that any pattern—notes, images, or words—could one day be composed by a general-purpose engine.',
    ),
  ),
  Book(
    id: 'bk-18',
    title: 'Deep Mornings',
    author: 'Jonas Lind',
    description:
        'A practical philosophy for reclaiming attention, building unhurried morning rituals, and doing meaningful creative work.',
    category: 'Self Development',
    rating: 4.8,
    pageCount: 224,
    publicationYear: 2025,
    popularityScore: 93,
    isTrending: true,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF6B3F1D),
    coverAccentColor: const Color(0xFFF6BD60),
    coverPattern: CoverPattern.horizonBand,
    chapters: _buildChapters(
      title: 'Deep Mornings',
      author: 'Jonas Lind',
      c1Title: 'The First Hour',
      c1Body:
          'Before notifications arrive, the mind is a still pond. Protecting even forty minutes changes the texture of the entire day.',
      c2Title: 'Single-Threaded Work',
      c2Body:
          'Context switching carries an invisible tax; finishing one meaningful task beats touching seven.',
      c3Title: 'Closing Rituals',
      c3Body:
          'Write down tomorrow’s first step before shutting the notebook so your evening stays truly yours.',
    ),
  ),
  Book(
    id: 'bk-19',
    title: 'Small Hinges',
    author: 'Maya Krishnan',
    description:
        'How tiny, repeatable environment tweaks outperform willpower when building lasting reading and learning habits.',
    category: 'Self Development',
    rating: 4.6,
    pageCount: 238,
    publicationYear: 2023,
    popularityScore: 82,
    coverColor: const Color(0xFF3A5A40),
    coverAccentColor: const Color(0xFFDAD7CD),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'Small Hinges',
      author: 'Maya Krishnan',
      c1Title: 'Friction by Design',
      c1Body:
          'A book placed on your pillow is read twice as often as one tucked on a high shelf.',
      c2Title: 'The Two-Minute Threshold',
      c2Body:
          'Lower the activation energy until starting feels effortless; momentum handles the rest.',
      c3Title: 'Identity in Motion',
      c3Body:
          'Every page turned is a quiet vote for the kind of thinker you are becoming.',
    ),
  ),
  Book(
    id: 'bk-20',
    title: 'Architecture of Attention',
    author: 'Dr. Clara Rossi',
    description:
        'Cognitive science insights into how memory, curiosity, and mental fatigue shape the way we read and decide.',
    category: 'Psychology',
    rating: 4.8,
    pageCount: 310,
    publicationYear: 2024,
    popularityScore: 90,
    isPopular: true,
    coverColor: const Color(0xFF264653),
    coverAccentColor: const Color(0xFF2A9D8F),
    coverPattern: CoverPattern.orbitalRings,
    chapters: _buildChapters(
      title: 'Architecture of Attention',
      author: 'Dr. Clara Rossi',
      c1Title: 'The Spotlight and the Lantern',
      c1Body:
          'Focused attention narrows the beam to solve a puzzle; diffuse attention widens it to notice unexpected connections.',
      c2Title: 'Memory Hooks',
      c2Body:
          'We remember stories and spatial layouts far better than isolated facts because emotion and context anchor recall.',
      c3Title: 'Rest as Consolidation',
      c3Body:
          'Stepping away from a desk is not wasted time—it is when the brain quietly files what you just learned.',
    ),
  ),
  Book(
    id: 'bk-21',
    title: 'The Quiet Bias',
    author: 'Prof. Samuel Grant',
    description:
        'An accessible exploration of everyday heuristics, confirmation traps, and how to think more clearly under uncertainty.',
    category: 'Psychology',
    rating: 4.5,
    pageCount: 284,
    publicationYear: 2022,
    popularityScore: 75,
    coverColor: const Color(0xFF1D3557),
    coverAccentColor: const Color(0xFFE63946),
    coverPattern: CoverPattern.diagonalSplit,
    chapters: _buildChapters(
      title: 'The Quiet Bias',
      author: 'Prof. Samuel Grant',
      c1Title: 'Fast Impressions',
      c1Body:
          'Our minds are pattern-completing engines, eager to turn two clues into a confident story.',
      c2Title: 'Base Rates Matter',
      c2Body:
          'Vivid anecdotes stick in memory, even when quiet statistics point elsewhere.',
      c3Title: 'Steelmanning Yourself',
      c3Body:
          'Asking "What would change my mind?" turns debate into genuine discovery.',
    ),
  ),
  Book(
    id: 'bk-22',
    title: 'Fog Over Blackthorn Pier',
    author: 'Arthur Doyle-Vane',
    description:
        'A retired watchmaker and a sharp-eyed journalist investigate a locked-room disappearance at a Victorian seaside hotel.',
    category: 'Mystery',
    rating: 4.8,
    pageCount: 336,
    publicationYear: 2024,
    popularityScore: 89,
    isTrending: true,
    coverColor: const Color(0xFF2D1E2F),
    coverAccentColor: const Color(0xFFC8553D),
    coverPattern: CoverPattern.archway,
    chapters: _buildChapters(
      title: 'Fog Over Blackthorn Pier',
      author: 'Arthur Doyle-Vane',
      c1Title: 'Room 14',
      c1Body:
          'The latch was bolted from the inside, the fireplace cold, yet the guest’s pocket watch still ticked on the mahogany desk.',
      c2Title: 'Tide Tables and Alibis',
      c2Body:
          'Only one person on the pier knew that the 11:15 train had been delayed by coastal fog.',
      c3Title: 'The Second Key',
      c3Body:
          'When Inspector Hale held the watch to the lamp, a faint engraving inside the lid answered everything.',
    ),
  ),
  Book(
    id: 'bk-23',
    title: 'The Manuscript Cipher',
    author: 'Helena Brooks',
    description:
        'A rare-book restorer finds marginalia coded in musical notation that leads to a missing Renaissance treatise.',
    category: 'Mystery',
    rating: 4.7,
    pageCount: 350,
    publicationYear: 2023,
    popularityScore: 83,
    coverColor: const Color(0xFF3C1518),
    coverAccentColor: const Color(0xFFD58936),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'The Manuscript Cipher',
      author: 'Helena Brooks',
      c1Title: 'Watermarks in the Binding',
      c1Body:
          'Held against the lightbox, the seventeenth-century endpaper revealed a double-clef watermark.',
      c2Title: 'Notes in the Margin',
      c2Body:
          'Each interval corresponded not to a melody, but to a shelf coordinate in the old monastery library.',
      c3Title: 'The Hidden Alcove',
      c3Body:
          'Behind a false oak panel lay the leather satchel, untouched for three hundred years.',
    ),
  ),
  Book(
    id: 'bk-24',
    title: 'Teaching with Curiosity',
    author: 'Dr. Evelyn Park',
    description:
        'Modern pedagogical methods that replace rote memorization with active inquiry, visual models, and joyful mastery.',
    category: 'Education',
    rating: 4.8,
    pageCount: 268,
    publicationYear: 2024,
    popularityScore: 85,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF1D3557),
    coverAccentColor: const Color(0xFFA8DADC),
    coverPattern: CoverPattern.editorialGrid,
    chapters: _buildChapters(
      title: 'Teaching with Curiosity',
      author: 'Dr. Evelyn Park',
      c1Title: 'Questions Before Answers',
      c1Body:
          'A student who has wrestled with a puzzle for five minutes remembers the solution ten times longer than one handed a formula.',
      c2Title: 'Scaffolding Without Crutches',
      c2Body:
          'Good guidance offers just enough structure to keep learners moving while preserving the thrill of discovery.',
      c3Title: 'Feedback Loops',
      c3Body:
          'Specific, timely encouragement builds confidence far better than a bare letter grade.',
    ),
  ),
  Book(
    id: 'bk-25',
    title: 'Visualizing Complexity',
    author: 'Mateo Alvarez',
    description:
        'A handbook for educators, designers, and writers on turning dense datasets and abstract concepts into clear diagrams.',
    category: 'Education',
    rating: 4.6,
    pageCount: 252,
    publicationYear: 2023,
    popularityScore: 78,
    coverColor: const Color(0xFF2B4162),
    coverAccentColor: const Color(0xFFFA9F42),
    coverPattern: CoverPattern.diagonalSplit,
    chapters: _buildChapters(
      title: 'Visualizing Complexity',
      author: 'Mateo Alvarez',
      c1Title: 'Hierarchy First',
      c1Body:
          'If everything on a diagram shouts in bold, the reader hears nothing at all.',
      c2Title: 'Spatial Metaphors',
      c2Body:
          'Timelines, flows, and clusters let the eye grasp relationships before a single caption is read.',
      c3Title: 'Clarity Over Ornament',
      c3Body:
          'Every line on the page should earn its ink.',
    ),
  ),
  Book(
    id: 'bk-26',
    title: 'The Midnight Conservatory',
    author: 'Soren Lindholm',
    description:
        'A botanical illustrator inherits a glasshouse of nocturnal blooms and uncovers the stories of the travelers who sent them.',
    category: 'Fiction',
    rating: 4.7,
    pageCount: 308,
    publicationYear: 2025,
    popularityScore: 88,
    isRecentlyAdded: true,
    coverColor: const Color(0xFF1A3A3A),
    coverAccentColor: const Color(0xFFE9C46A),
    coverPattern: CoverPattern.archway,
    chapters: _buildChapters(
      title: 'The Midnight Conservatory',
      author: 'Soren Lindholm',
      c1Title: 'Glass Under Moonlight',
      c1Body:
          'At eleven o’clock, the night-blooming cereus began to unfurl its white petals, filling the conservatory with vanilla and rain.',
      c2Title: 'Pressed Specimens',
      c2Body:
          'Tucked inside each herbarium folder was a railway ticket or a sketch of a distant valley.',
      c3Title: 'New Seedlings',
      c3Body:
          'Come spring, the doors opened to neighborhood children carrying sketchbooks of their own.',
    ),
  ),
  Book(
    id: 'bk-27',
    title: 'Edge Computing Field Guide',
    author: 'Tariq Hassan',
    description:
        'How local-first software, offline sync, and compact runtimes bring speed and privacy back to everyday apps.',
    category: 'Technology',
    rating: 4.7,
    pageCount: 280,
    publicationYear: 2024,
    popularityScore: 84,
    coverColor: const Color(0xFF1F2D3D),
    coverAccentColor: const Color(0xFF64DFDF),
    coverPattern: CoverPattern.orbitalRings,
    chapters: _buildChapters(
      title: 'Edge Computing Field Guide',
      author: 'Tariq Hassan',
      c1Title: 'Zero-Latency Local State',
      c1Body:
          'When data lives on the device first, every tap feels instantaneous—even on a commuter train through a tunnel.',
      c2Title: 'Conflict-Free Merging',
      c2Body:
          'Designing deterministic merge rules removes the fear of lost edits.',
      c3Title: 'Privacy by Architecture',
      c3Body:
          'The safest data is the data you never needed to send across the wire.',
    ),
  ),
  Book(
    id: 'bk-28',
    title: 'The Art of Technical Writing',
    author: 'Grace O’Connor',
    description:
        'Write crisp documentation, READMEs, and architectural proposals that engineers and non-engineers alike love reading.',
    category: 'Education',
    rating: 4.8,
    pageCount: 216,
    publicationYear: 2025,
    popularityScore: 90,
    isPopular: true,
    coverColor: const Color(0xFF2D3142),
    coverAccentColor: const Color(0xFFEF8354),
    coverPattern: CoverPattern.minimalFrame,
    chapters: _buildChapters(
      title: 'The Art of Technical Writing',
      author: 'Grace O’Connor',
      c1Title: 'Lead with Context',
      c1Body:
          'Before explaining how a flag works, tell the reader what problem it solves and when to reach for it.',
      c2Title: 'Examples Are Anchors',
      c2Body:
          'One concrete, runnable snippet replaces three paragraphs of abstract prose.',
      c3Title: 'Editing for Brevity',
      c3Body:
          'Cut every word that does not carry meaning, and your remaining sentences shine.',
    ),
  ),
];
