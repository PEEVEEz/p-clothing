import { useMemo } from "react";
import type { Item } from "../types";
import { fillColor, strokeColor } from "../data";

type Props = {
  item: Item;
  index: number;
  isActive: boolean;
  totalAngle: number;
  svgCenterX: number;
  svgCenterY: number;
  activeColor: string;
  radiansPerItem: number;
  handleAction: (name: string) => void;
};

export function RadialMenuItem({
  item,
  index,
  isActive,
  svgCenterX,
  svgCenterY,
  activeColor,
  handleAction,
  radiansPerItem,
}: Props) {
  const outerRadius = 250;
  const innerRadius = 130;
  const radiansGap = (1.5 * Math.PI) / 180;

  const borderPath = useMemo(() => {
    const startAngle = (radiansPerItem + radiansGap) * index;
    const endAngle = startAngle + radiansPerItem;

    const borderRadius = outerRadius + 3.4;

    const x1Outer = svgCenterX + borderRadius * Math.cos(startAngle);
    const y1Outer = svgCenterY + borderRadius * Math.sin(startAngle);
    const x2Outer = svgCenterX + borderRadius * Math.cos(endAngle);
    const y2Outer = svgCenterY + borderRadius * Math.sin(endAngle);

    return `M${x1Outer},${y1Outer} A${borderRadius},${borderRadius} 0 0,1 ${x2Outer},${y2Outer}`;
  }, [index, outerRadius, radiansGap, radiansPerItem, svgCenterX, svgCenterY]);

  const sectorPath = useMemo(() => {
    const startAngle = (radiansPerItem + radiansGap) * index;
    const endAngle = startAngle + radiansPerItem;

    const x1Outer = svgCenterX + outerRadius * Math.cos(startAngle);
    const y1Outer = svgCenterY + outerRadius * Math.sin(startAngle);
    const x2Outer = svgCenterX + outerRadius * Math.cos(endAngle);
    const y2Outer = svgCenterY + outerRadius * Math.sin(endAngle);

    const x1Inner = svgCenterX + innerRadius * Math.cos(startAngle);
    const y1Inner = svgCenterY + innerRadius * Math.sin(startAngle);
    const x2Inner = svgCenterX + innerRadius * Math.cos(endAngle);
    const y2Inner = svgCenterY + innerRadius * Math.sin(endAngle);

    return `M${x1Inner},${y1Inner} L${x1Outer},${y1Outer} A${outerRadius},${outerRadius} 0 0,1 ${x2Outer},${y2Outer} L${x2Inner},${y2Inner} A${innerRadius},${innerRadius} 0 0,0 ${x1Inner},${y1Inner} Z`;
  }, [
    index,
    radiansGap,
    innerRadius,
    outerRadius,
    radiansPerItem,
    svgCenterX,
    svgCenterY,
  ]);

  const imageSize = 60;
  const { x, y } = useMemo<{ x: number; y: number }>(() => {
    const angle = (radiansPerItem + radiansGap) * (index + 0.5);

    let x =
      svgCenterX +
      ((innerRadius + outerRadius) / 2) * Math.cos(angle) -
      imageSize / 2;
    let y =
      svgCenterY +
      ((innerRadius + outerRadius) / 2) * Math.sin(angle) -
      imageSize / 2;

    // shit
    if (item.name === "top") {
      x = x + 9;
      y = y - 2;
    } else if (item.name === "vest") {
      x = x + 2;
      y = y - 3;
    }

    return { x, y };
  }, [
    index,
    radiansGap,
    innerRadius,
    outerRadius,
    radiansPerItem,
    svgCenterX,
    svgCenterY,
    item.name,
  ]);

  const handleClick = () => {
    handleAction(item.name);
  };

  return (
    <g key={index} onClick={handleClick} className="cursor-pointer group">
      <path
        fill="none"
        d={borderPath}
        strokeWidth="7"
        stroke={!isActive ? strokeColor : activeColor}
      />

      <path d={sectorPath} fill={fillColor} />
      <image
        x={x}
        y={y}
        href={item.image}
        width={imageSize}
        height={imageSize}
        className="group-active:scale-[1.005] origin-center transition-transform"
      />
    </g>
  );
}
