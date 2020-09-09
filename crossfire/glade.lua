local top,left=0,0

function line() top,left = top+1,0 end

function cell(label)
  return function(name)
    print(string.format(
      LABEL_TEMPLATE,
      'label_'..name..'_header',
      '\n      <property name="label" translatable="yes">'..label..'</property>',
      top, top+1, left, left+1))
    print(string.format(
      LABEL_TEMPLATE,
      'label_'..name, '',
      top, top+1, left+1, left+2))
    left = left+2
  end
end

function draw()
  cell 'Strength' 'str';     cell ' | Intelligence' 'int'; cell ' | Damage' 'dam';   line()
  cell 'Dexterity' 'dex';    cell ' | Wisdom' 'wis';       cell ' | WC' 'wc';        line()
  cell 'Constitution' 'con'; cell ' | Power' 'pow';        cell ' | Armour' 'armor'; line()
  cell 'Charisma' 'cha';     cell ' | ' 'spacer';          cell ' | AC' 'ac';
end

LABEL_TEMPLATE = [[
  <child>
    <object class="GtkLabel" id="%s">
      <property name="visible">True</property>
      <property name="xalign">0</property>%s
    </object>
    <packing>
      <property name="top_attach">%d</property>
      <property name="bottom_attach">%d</property>
      <property name="left_attach">%d</property>
      <property name="right_attach">%d</property>
      <property name="x_options">GTK_FILL</property>
      <property name="y_options"></property>
    </packing>
  </child>]]

return draw()
