import { items } from "../data";
import { useState } from "react";
import { CenterItems } from "./CenterItems";
import { RadialMenuItem } from "./RadialMenuItem";
import { action, isEnvBrowser, useNuiEvent } from "../utils";

export function RadialMenu() {
  const width = 560;
  const height = 560;
  const totalAngle = 360 - 1.5 * items.length;
  const anglePerItem = totalAngle / items.length;
  const radiansPerItem = (anglePerItem * Math.PI) / 180;

  const [open, setOpen] = useState(isEnvBrowser() ? true : false);
  const [active, setActive] = useState<{ [name: string]: boolean }>({});

  useNuiEvent<boolean>("open", (state) => {
    setOpen(state);
  });

  const handleAction = async (name: string) => {
    const newState = await action(name);

    if (name === "reset") {
      setActive({});
      return;
    }

    setActive((current) => {
      return { ...current, [name]: newState };
    });
  };

  return (
    <>
      <div
        className={`absolute left-[70%] top-[50%] -translate-x-1/2 -translate-y-1/2 ${
          open ? "block" : "hidden"
        }`}
      >
        <svg width={width} height={height}>
          {items.map((item, index) => (
            <RadialMenuItem
              key={index}
              item={item}
              index={index}
              svgCenterX={width / 2}
              svgCenterY={height / 2}
              totalAngle={totalAngle}
              handleAction={handleAction}
              isActive={active[item.name]}
              radiansPerItem={radiansPerItem}
            />
          ))}

          <CenterItems active={active} handleAction={handleAction} />
        </svg>
      </div>
    </>
  );
}

export default RadialMenu;
