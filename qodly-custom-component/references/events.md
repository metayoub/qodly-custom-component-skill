# Qodly Custom Component — Events

## Declaring Events in Config

In `*.config.tsx`, `info.events` defines which events the component can emit:

```tsx
info: {
  events: [
    { label: 'On Click', value: 'onclick' },
    { label: 'On Blur', value: 'onblur' },
    { label: 'On Focus', value: 'onfocus' },
    { label: 'On MouseEnter', value: 'onmouseenter' },
    { label: 'On MouseLeave', value: 'onmouseleave' },
    { label: 'On KeyDown', value: 'onkeydown' },
    { label: 'On KeyUp', value: 'onkeyup' },
  ],
},
```

Custom events (e.g. Tree):
```tsx
events: [
  { label: 'On Node Click', value: 'onnodeclick' },
  { label: 'On Node Action', value: 'onnodeaction' },
  { label: 'On Node Expand', value: 'onnodeexpand' },
  { label: 'On Node Ctrl Click', value: 'onnodectrlclick' },
],
```

## Props Interface

Add event handlers to the props interface:

```tsx
export interface IMyProps extends webforms.ComponentProps {
  onclick?: (payload: EventPayload) => void;
  onnodeclick?: (payload: TreeNodeEventPayload) => void;
}
```

## Wiring in Build/Render

Events are passed as props. Invoke when the action occurs:

```tsx
const handleClick = () => {
  onclick?.({ node, data, ctrlKey });
};

return <button onClick={handleClick}>...</button>;
```

## Event Payloads

Define payload types in config and use consistently in Build and Render.
