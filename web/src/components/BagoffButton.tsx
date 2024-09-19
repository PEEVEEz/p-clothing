import { fillColor, strokeColor } from "../data";
import BagOffImage from "../assets/images/bagoff.png";

type Props = {
  isActive: boolean;
  activeColor: string;
  handleAction: (name: string) => void;
};

export default function BagOffButton({
  handleAction,
  isActive,
  activeColor,
}: Props) {
  const cx = "9";
  const cy = "90";
  const imageSize = "3rem";

  return (
    <g onClick={() => handleAction("bagoff")} className="cursor-pointer">
      <circle cx={`${cx}%`} cy={`${cy}%`} r="30" fill={fillColor} />

      <circle
        r={32}
        fill="none"
        cx={`${cx}%`}
        cy={`${cy}%`}
        strokeWidth={5}
        stroke={isActive ? activeColor : strokeColor}
      />

      <image
        href={BagOffImage}
        width={imageSize}
        height={imageSize}
        x={`calc(${cx}% - ${imageSize} / 2)`}
        y={`calc(${cy}% - ${imageSize} / 2)`}
      />
    </g>
  );
}
