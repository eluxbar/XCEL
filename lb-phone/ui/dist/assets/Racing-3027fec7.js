import{j as e,a,F as g}from"./jsx-runtime-f40812bf.js";import{s as h,u as r,A as S,m as I,c as k,bB as y,an as d,bD as U,a3 as b,b9 as x,bE as C,aL as F,bF as M}from"./index.esm-e1f47206.js";import{r as o}from"./number-28525126.js";const R=h({stats:{rating:1250,winnings:13e8,wins:25,previous:"2/15"},races:[{name:"Sandy Shores",timestamp:1627776e3,signedUp:!0},{name:"Paleto Bay",timestamp:1627776e3,signedUp:!0},{name:"Los Santos",timestamp:1627776e3,signedUp:!1},{name:"Strawberry",timestamp:1627776e3,signedUp:!1},{name:"Vinewood",timestamp:1627776e3,signedUp:!1}]}),n=h(null);function w(){var t,v,N,p,u,f;const s=r(R),l=r(n),c=i=>i?i<1e3?i:i<1e6?`${o(i/1e3,3)}K`:i<1e9?`${o(i/1e6,3)}M`:`${o(i/1e9,3)}B`:"0";return e(S,{children:l?a(I.div,{className:"view-wrapper",initial:{opacity:0,x:50},animate:{opacity:1,x:0},exit:{opacity:0,x:50},transition:{duration:.2,ease:"easeInOut"},children:[e("div",{className:"gradient blue"}),a("div",{className:"racing-header",children:[a("div",{className:"back",onClick:()=>n.reset(),children:[e(k,{})," Home"]}),e("div",{className:"title",children:l.name}),e("div",{className:"profile-image",children:"KL"})]}),a("section",{children:[e("div",{className:"subtitle",children:"Info"}),e("div",{className:"items",children:a("div",{className:"item",children:[e(y,{}),a("div",{className:"border",children:[a("div",{className:"info",children:[e("div",{className:"title",children:"Participants"}),e("div",{className:"description",children:"Starts in 25 minutes"})]}),a("div",{className:"details",children:[l.participants,e(d,{className:"chevron"})]})]})]})})]})]}):a(g,{children:[e("div",{className:"gradient"}),a("div",{className:"racing-header",children:[e("div",{className:"title",children:"Home"}),e("div",{className:"profile-image",children:"KL"})]}),a("div",{className:"panel",children:[a("div",{className:"panel-header",children:[e(U,{}),"Statistics"]}),a("div",{className:"panel-content",children:[a("div",{className:"item",children:[e("div",{className:"title","data-color":"red",children:"Rating"}),a("div",{className:"value",children:[e("span",{children:s.stats.rating}),"elo"]})]}),a("div",{className:"item",children:[e("div",{className:"title","data-color":"yellow",children:"Winnings"}),a("div",{className:"value",children:[e("span",{children:c(s.stats.winnings)}),"usd"]})]}),a("div",{className:"item",children:[e("div",{className:"title","data-color":"green",children:"Wins"}),a("div",{className:"value",children:[e("span",{children:s.stats.wins}),"total"]})]}),a("div",{className:"item",children:[e("div",{className:"title","data-color":"blue",children:"Previous"}),a("div",{className:"value",children:[e("span",{children:s.stats.previous}),"pos"]})]})]})]}),((v=(t=s==null?void 0:s.races)==null?void 0:t.filter(i=>i.signedUp))==null?void 0:v.length)>0&&a("section",{children:[e("div",{className:"subtitle",children:"Signed up races"}),e("div",{className:"items",children:(N=s==null?void 0:s.races)==null?void 0:N.filter(i=>i.signedUp).map(i=>a("div",{className:"item",onClick:()=>{n.set({...i,participants:Math.floor(Math.random()*20)+1})},children:[e(b,{}),a("div",{className:"border",children:[a("div",{className:"info",children:[e("div",{className:"title",children:i.name}),e("div",{className:"description",children:"Starts in 10 minutes"})]}),e(d,{className:"chevron"})]})]}))})]}),((u=(p=s==null?void 0:s.races)==null?void 0:p.filter(i=>!i.signedUp))==null?void 0:u.length)>0&&a("section",{children:[e("div",{className:"subtitle",children:"Available races"}),e("div",{className:"items",children:(f=s==null?void 0:s.races)==null?void 0:f.filter(i=>!i.signedUp).map(i=>a("div",{className:"item",onClick:()=>{n.set({...i,participants:Math.floor(Math.random()*20)+1})},children:[e(b,{}),a("div",{className:"border",children:[a("div",{className:"info",children:[e("div",{className:"title",children:i.name}),e("div",{className:"description",children:"Starts in 10 minutes"})]}),e(d,{className:"chevron"})]})]}))})]})]})})}function H(){const s=r(m);return e("div",{className:"racing-footer",children:[{icon:e(x,{}),title:"Home",value:"home"},{icon:e(C,{}),title:"Leaderboard",value:"leaderboard"},{icon:e(F,{}),title:"Tracks",value:"tracks"},{icon:e(M,{}),title:"Feed",value:"feed"}].map((c,t)=>a("div",{className:"item","data-active":s===c.value,onClick:()=>m.set(c.value),children:[c.icon,e("div",{className:"title",children:c.title})]},t))})}const m=h("home");function B(){const s=r(m),l={home:e(w,{})};return a("div",{className:"racing-container",children:[l==null?void 0:l[s],e(H,{})]})}export{m as CurrentView,B as default};
