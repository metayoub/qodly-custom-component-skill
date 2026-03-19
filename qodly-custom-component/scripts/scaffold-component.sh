#!/usr/bin/env bash
# Scaffold a new Qodly custom component inside src/components/
# Usage: ./scaffold-component.sh ComponentName [--datasource array|entitysel]
# Run from the root of your Qodly component project (where src/components/ exists)

set -e

NAME=""
DS_TYPE="array"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --datasource)
      shift
      DS_TYPE="${1:-array}"
      shift
      ;;
    *)
      NAME="$1"
      shift
      ;;
  esac
done

[[ -n "$NAME" ]] || { echo "Usage: $0 ComponentName [--datasource array|entitysel]"; exit 1; }

# Convert to PascalCase (e.g. my-component -> MyComponent)
PASCAL=$(echo "$NAME" | tr '-' ' ' | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' | tr -d ' ')
# CSS class: MyComponent -> my-component
LOWER=$(echo "$PASCAL" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]')

COMP_DIR="src/components/${PASCAL}"
mkdir -p "$COMP_DIR"

# index.tsx
cat > "$COMP_DIR/index.tsx" << EOF
import config, { I${PASCAL}Props } from './${PASCAL}.config';
import { T4DComponent, useEnhancedEditor } from '@ws-ui/webform-editor';
import Build from './${PASCAL}.build';
import Render from './${PASCAL}.render';

const ${PASCAL}: T4DComponent<I${PASCAL}Props> = (props) => {
  const { enabled } = useEnhancedEditor((state) => ({
    enabled: state.options.enabled,
  }));

  return enabled ? <Build {...props} /> : <Render {...props} />;
};

${PASCAL}.craft = config.craft;
${PASCAL}.info = config.info;
${PASCAL}.defaultProps = config.defaultProps;

export default ${PASCAL};
EOF

# config.tsx
cat > "$COMP_DIR/${PASCAL}.config.tsx" << EOF
import { EComponentKind, T4DComponentConfig } from '@ws-ui/webform-editor';
import { Settings } from '@ws-ui/webform-editor';
import { MdExtension } from 'react-icons/md';

import ${PASCAL}Settings, { BasicSettings } from './${PASCAL}.settings';

export default {
  craft: {
    displayName: '${PASCAL}',
    kind: EComponentKind.BASIC,
    props: {
      name: '',
      classNames: [],
      events: [],
    },
    related: {
      settings: Settings(${PASCAL}Settings, BasicSettings),
    },
  },
  info: {
    displayName: '${PASCAL}',
    exposed: true,
    icon: MdExtension,
    events: [
      { label: 'On Click', value: 'onclick' },
      { label: 'On Blur', value: 'onblur' },
      { label: 'On Focus', value: 'onfocus' },
    ],
    datasources: {
      accept: ['${DS_TYPE}'],
    },
  },
  defaultProps: {
    style: {
      height: '200px',
      width: '100%',
    },
  },
} as T4DComponentConfig<I${PASCAL}Props>;

export interface I${PASCAL}Props extends webforms.ComponentProps {
  label?: string;
}
EOF

# settings.ts
cat > "$COMP_DIR/${PASCAL}.settings.ts" << EOF
import { ESetting, TSetting } from '@ws-ui/webform-editor';
import { BASIC_SETTINGS, DEFAULT_SETTINGS, load } from '@ws-ui/webform-editor';

const commonSettings: TSetting[] = [
  {
    key: 'label',
    label: 'Label',
    type: ESetting.TEXT_FIELD,
    defaultValue: '',
  },
];

const Settings: TSetting[] = [
  {
    key: 'properties',
    label: 'Properties',
    type: ESetting.GROUP,
    components: commonSettings,
  },
  ...load(DEFAULT_SETTINGS).filter(
    'style.overflow',
    'display',
    'style.boxShadow',
    'style.textShadow',
    'style.textAlign',
    'style.textDecorationLine',
    'style.fontStyle',
    'style.textTransform',
  ),
];

export const BasicSettings: TSetting[] = [
  ...commonSettings,
  ...load(BASIC_SETTINGS).filter(
    'style.overflow',
    'display',
    'style.boxShadow',
    'style.textShadow',
    'style.textAlign',
    'style.textDecorationLine',
    'style.fontStyle',
    'style.textTransform',
  ),
];

export default Settings;
EOF

# build.tsx
cat > "$COMP_DIR/${PASCAL}.build.tsx" << EOF
import { useEnhancedNode } from '@ws-ui/webform-editor';
import cn from 'classnames';
import { FC } from 'react';
import { I${PASCAL}Props } from './${PASCAL}.config';

const ${PASCAL}: FC<I${PASCAL}Props> = ({
  label = '',
  style,
  className,
  classNames = [],
}) => {
  const {
    connectors: { connect },
  } = useEnhancedNode();

  return (
    <div ref={connect} style={style} className={cn('${LOWER}', className, classNames)}>
      <span>{label || '${PASCAL}'}</span>
    </div>
  );
};

export default ${PASCAL};
EOF

# render.tsx
if [[ "$DS_TYPE" == "entitysel" ]]; then
  cat > "$COMP_DIR/${PASCAL}.render.tsx" << EOF
import { useRenderer } from '@ws-ui/webform-editor';
import cn from 'classnames';
import { FC } from 'react';
import { I${PASCAL}Props } from './${PASCAL}.config';

const ${PASCAL}: FC<I${PASCAL}Props> = ({
  label = '',
  style,
  className,
  classNames = [],
}) => {
  const { connect } = useRenderer();

  return (
    <div ref={connect} style={style} className={cn('${LOWER}', className, classNames)}>
      <span>{label || '${PASCAL}'}</span>
    </div>
  );
};

export default ${PASCAL};
EOF
else
  cat > "$COMP_DIR/${PASCAL}.render.tsx" << EOF
import { useRenderer, useSources } from '@ws-ui/webform-editor';
import cn from 'classnames';
import { FC, useEffect, useState } from 'react';
import { I${PASCAL}Props } from './${PASCAL}.config';

const ${PASCAL}: FC<I${PASCAL}Props> = ({
  label = '',
  style,
  className,
  classNames = [],
}) => {
  const { connect } = useRenderer();
  const {
    sources: { datasource: ds },
  } = useSources();
  const [value, setValue] = useState<any[]>([]);

  useEffect(() => {
    if (!ds) return;
    const listener = async () => {
      const v = await ds.getValue<Array<any>>();
      if (v) setValue(v);
    };
    listener();
    ds.addListener('changed', listener);
    return () => ds.removeListener('changed', listener);
  }, [ds]);

  return (
    <div ref={connect} style={style} className={cn('${LOWER}', className, classNames)}>
      <span>{label || '${PASCAL}'}</span>
      {value.length > 0 && <pre>{JSON.stringify(value.slice(0, 3))}</pre>}
    </div>
  );
};

export default ${PASCAL};
EOF
fi

echo "Created $COMP_DIR/"
echo "Add to src/components/index.tsx:"
echo "  import ${PASCAL} from './${PASCAL}';"
echo "  export default { ...existing, ${PASCAL} };"
