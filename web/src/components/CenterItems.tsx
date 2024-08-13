import { useState } from "react";
import { fillColor, strokeColor } from "../data";
import ResetImage from "../assets/images/reset.png";
import ShirtImage from "../assets/images/shirt.png";
import PantsImage from "../assets/images/pants.png";

const spinDuration = 1000; // ms

type ResetButtonProps = {
  handleAction: (name: string) => void;
};

function ResetButton({ handleAction }: ResetButtonProps) {
  const [spinning, setSpinning] = useState(false);

  const handleClick = () => {
    if (spinning) return;

    setSpinning(true);
    setTimeout(() => {
      handleAction("reset");
      setSpinning(false);
    }, spinDuration);
  };

  const cx = "50";
  const cy = "50";
  const imageSize = "4rem";

  return (
    <g
      className={`cursor-pointer ${
        spinning ? `rotate-[-360deg] origin-center transition-transform` : ""
      }`}
      style={{
        transitionDuration: spinning ? `${spinDuration}ms` : "",
      }}
      onClick={handleClick}
    >
      <circle cx={`${cx}%`} cy={`${cy}%`} r="40" fill={fillColor} />

      <circle
        r={42}
        fill="none"
        strokeWidth={5}
        stroke={strokeColor}
        cx={`${cx}%`}
        cy={`${cy}%`}
      />

      <image
        width={imageSize}
        height={imageSize}
        href={ResetImage}
        x={`calc(${cx}% - ${imageSize} / 2)`}
        y={`calc(${cy}% - ${imageSize} / 2)`}
      />
    </g>
  );
}

type Props = {
  isActive: boolean;
  activeColor: string;
  handleAction: (name: string) => void;
};

function PantsButton({ handleAction, isActive, activeColor }: Props) {
  const cx = "34.5";
  const cy = "50";
  const imageSize = "3rem";

  return (
    <g onClick={() => handleAction("pants")} className="cursor-pointer">
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
        href={PantsImage}
        width={imageSize}
        height={imageSize}
        x={`calc(${cx}% - ${imageSize} / 2)`}
        y={`calc(${cy}% - ${imageSize} / 2)`}
      />
    </g>
  );
}

function ShirtButton({ handleAction, isActive, activeColor }: Props) {
  const cx = "65.5";
  const cy = "50";
  const imageSize = "3rem";

  return (
    <g onClick={() => handleAction("shirt")} className="cursor-pointer">
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
        width={imageSize}
        height={imageSize}
        href={ShirtImage}
        x={`calc(${cx}% - ${imageSize} / 2)`}
        y={`calc(${cy}% - ${imageSize} / 2)`}
      />
    </g>
  );
}

type CenterItemsProps = {
  activeColor: string;
  active: { [name: string]: boolean };
  handleAction: (name: string) => void;
};

export function CenterItems({
  active,
  activeColor,
  handleAction,
}: CenterItemsProps) {
  return (
    <>
      <PantsButton
        activeColor={activeColor}
        handleAction={handleAction}
        isActive={!!active["pants"]}
      />
      <ResetButton handleAction={handleAction} />
      <ShirtButton
        activeColor={activeColor}
        handleAction={handleAction}
        isActive={!!active["shirt"]}
      />
    </>
  );
}
