varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int u_numColors;
uniform vec4 u_colorOrig[8]; // Cores originais da sua sprite
uniform vec4 u_colorNew[8];  // Cores novas (paleta verde/amarelo)

void main() {
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Procura se a cor do pixel atual existe na nossa lista original
    for (int i = 0; i < u_numColors; i++) {
        if (distance(texColor, u_colorOrig[i]) < 0.01) {
            texColor = u_colorNew[i];
            break;
        }
    }
    
    gl_FragColor = v_vColour * texColor;
}