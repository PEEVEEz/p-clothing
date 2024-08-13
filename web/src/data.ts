import type { Item } from "./types";
import BagImage from "./assets/images/bag.png";
import EarImage from "./assets/images/ear.png";
import HatImage from "./assets/images/hat.png";
import TopImage from "./assets/images/top.png";
import HairImage from "./assets/images/hair.png";
import MaskImage from "./assets/images/mask.png";
import NeckImage from "./assets/images/neck.png";
import VestImage from "./assets/images/vest.png";
import VisorImage from "./assets/images/visor.png";
import ShoesImage from "./assets/images/shoes.png";
import WatchImage from "./assets/images/watch.png";
import GlovesImage from "./assets/images/gloves.png";
import GlassesImage from "./assets/images/glasses.png";
import BraceletImage from "./assets/images/bracelet.png";

export const items: Item[] = [
  { image: VestImage, name: "vest" },
  { image: TopImage, name: "top" },
  { image: GlovesImage, name: "gloves" },
  { image: VisorImage, name: "visor" },
  { image: HatImage, name: "hat" },
  { image: ShoesImage, name: "shoes" },
  { image: MaskImage, name: "mask" },
  { image: HairImage, name: "hair" },
  { image: BagImage, name: "bag" },
  { image: GlassesImage, name: "glasses" },
  { image: EarImage, name: "ear" },
  { image: NeckImage, name: "neck" },
  { image: WatchImage, name: "watch" },
  { image: BraceletImage, name: "bracelet" },
];

export const fillColor = "rgba(0,0,0,0.5)";
export const strokeColor = "rgba(0,0,0, 0.7)";
