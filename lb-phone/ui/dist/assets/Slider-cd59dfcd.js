import{r,j as s}from"./jsx-runtime-f40812bf.js";import{I as c}from"./Phone-1ddf01c8.js";function d(e){const[n,i]=r.useState(e.value),[a,t]=r.useState(u(n,e.min,e.max));return s(c,{type:"range",className:"sliderInput",min:e.min,max:e.max,defaultValue:n,step:e.step,id:e.id,onChange:f=>{let l=parseFloat(f.target.value);i(l),e.onChange(l),t(u(l,e.min,e.max))},style:{background:`linear-gradient(to right, #0a84ff 0%, #0a84ff ${a}%, #636366 ${a}%, #636366 100%)`}})}function u(e,n,i,a){var t=(e-n)*100/(i-n);return t>100?a?(t=(a-e)*100/(a-i),t<0&&(t=0)):t=100:t<0&&(t=0),t}export{d as S};
