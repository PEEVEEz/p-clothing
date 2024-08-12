import { items } from "../data";
import { CenterItems } from "./CenterItems";
import { RadialMenuItem } from "./RadialMenuItem";
import { action, isEnvBrowser, useNuiEvent } from "../utils";
import { useCallback, useEffect, useRef, useState } from "react";
import { Position } from "../types";

export function RadialMenu() {
  const width = 560;
  const height = 560;
  const totalAngle = 360 - 1.5 * items.length;
  const anglePerItem = totalAngle / items.length;
  const radiansPerItem = (anglePerItem * Math.PI) / 180;

  const [cooldown, setCooldown] = useState(false);
  const ref = useRef<HTMLDivElement | null>(null);
  const [open, setOpen] = useState(isEnvBrowser() ? true : false);
  const [position, setPosition] = useState<Position>({ x: 70, y: 50 });
  const [active, setActive] = useState<{ [name: string]: boolean }>({});

  const handleAction = useCallback(
    async (name: string, data?: unknown) => {
      if (cooldown && name !== "cursor") return;

      setCooldown(true);
      const newState = await action(name, data);
      setCooldown(false);

      if (name === "reset") {
        setActive({});
        return;
      }

      setActive((current) => ({
        ...current,
        [name]: newState,
      }));
    },
    [cooldown]
  );

  useNuiEvent<boolean>("open", (state) => {
    setOpen(state);
  });

  useNuiEvent<Position>("position", (state) => {
    setPosition(state);
  });

  useEffect(() => {
    if (open && ref.current) {
      const rect = ref.current.getBoundingClientRect();
      handleAction("cursor", {
        x: (rect.x + rect.width / 2) / window.innerWidth,
        y: (rect.y + rect.height / 2) / window.innerHeight,
      });
    }

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  return (
    <>
      {isEnvBrowser() && <button onClick={() => setOpen(!open)}>TOGGLE</button>}

      <div
        ref={ref}
        style={{ width, height, left: `${position.x}%`, top: `${position.y}%` }}
        className={`absolute -translate-x-1/2 -translate-y-1/2 ${
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
