import{r as c,a as r,j as a}from"./jsx-runtime-f40812bf.js";import{f as v,u as W,p as $,L as s,I as K,T as j,C as R,h as U,v as H,t as q,B,b as f,O as b}from"./Phone-1ddf01c8.js";import{u as N,as as I}from"./index.esm-e1f47206.js";import{f as G}from"./number-28525126.js";function ee(){var w;const l=N(f.Settings),L=N(f.PhoneNumber),[M,O]=c.useState(!1),[E,A]=c.useState([]),[C,o]=c.useState(!1),[e,p]=c.useState(null),[u,S]=c.useState(0),[i,d]=c.useState(!1),[m,g]=c.useState(!1),[T,_]=c.useState(""),[k,y]=c.useState(""),[D,x]=c.useState([]);c.useEffect(()=>{const t=setTimeout(()=>_(k),500);return()=>clearTimeout(t)},[k]),c.useEffect(()=>{T.length>0&&v("MarketPlace",{action:"search",query:T}).then(t=>{t&&x(t)})},[T]),c.useEffect(()=>{v("MarketPlace",{action:"getPosts",page:0}).then(t=>{t&&t.length>0?A(t):d(!0)}),v("isAdmin").then(t=>O(t))},[]);const X=()=>{var P,n;if(!(e!=null&&e.title)||!(e!=null&&e.description)||!(e!=null&&e.price)||((P=e==null?void 0:e.attachments)==null?void 0:P.length)===0){let h;switch(!0){case!(e!=null&&e.title):h=s("APPS.MARKETPLACE.ERROR_POPUP.NO_TITLE");break;case!(e!=null&&e.description):h=s("APPS.MARKETPLACE.ERROR_POPUP.NO_DESCRIPTION");break;case!(e!=null&&e.price):h=s("APPS.MARKETPLACE.ERROR_POPUP.NO_PRICE");break;case((n=e==null?void 0:e.attachments)==null?void 0:n.length)===0:h=s("APPS.MARKETPLACE.ERROR_POPUP.NO_ATTACHMENTS")}R.PopUp.set({title:s("APPS.MARKETPLACE.ERROR_POPUP.TITLE"),description:h,buttons:[{title:s("APPS.MARKETPLACE.ERROR_POPUP.OK")}]});return}let t={...e,number:L};v("MarketPlace",{action:"sendPost",data:t}).then(h=>{h&&(A([{...t,id:h,timestamp:new Date().getTime()},...E]),o(!1))})},F=t=>{t&&R.PopUp.set({title:s("APPS.MARKETPLACE.DELETE_POPUP.TITLE"),description:s("APPS.MARKETPLACE.DELETE_POPUP.TEXT"),buttons:[{title:s("APPS.MARKETPLACE.DELETE_POPUP.CANCEL")},{title:s("APPS.MARKETPLACE.DELETE_POPUP.PROCEED"),color:"red",cb:()=>{v("MarketPlace",{action:"deletePost",id:t}).then(P=>{P&&A(E.filter(n=>n.id!==t))})}}]})},V=()=>{if(i||m)return;let t=document.querySelector("#last");if(!t)return;!H(t)&&(g(!0),v("MarketPlace",{action:"getPosts",page:u+1}).then(n=>{n&&n.length>0?(A([...E,...n]),g(!1),n.length<15&&d(!0)):d(!0)}),S(n=>n+1))};return W("marketPlace:newPost",t=>{l.airplaneMode||A([t,...E])}),c.useEffect(()=>{p(null)},[C]),r("div",{className:"marketplace-container",children:[a("div",{className:"marketplace-header",children:a($,{theme:"dark",placeholder:s("APPS.MARKETPLACE.SEARCH"),onChange:t=>y(t.target.value)})}),a("div",{className:"add",onClick:()=>o(!0),children:a(I,{})}),a("div",{className:"marketplace-wrapper",children:a("div",{className:"posts",onScroll:V,children:(T.length>0?D:E).map((t,P)=>{let n=P===E.length-1?"last":"";return a(Y,{post:t,last:n,deletePost:F,isAdmin:M},P)})})}),C&&r("div",{className:"new-post-container",children:[r("div",{className:"new-post-header",children:[a("div",{className:"cancel",onClick:()=>o(!1),children:s("APPS.MARKETPLACE.CANCEL")}),a("div",{className:"title",children:s("APPS.MARKETPLACE.NEW_POST")}),a("div",{})]}),r("div",{className:"new-post-body",children:[r("div",{className:"item",children:[a("div",{className:"title",children:s("APPS.MARKETPLACE.TITLE")}),a(K,{type:"text",placeholder:"Title",maxLength:50,onChange:t=>p({...e,title:t.target.value})})]}),r("div",{className:"item",children:[a("div",{className:"title",children:s("APPS.MARKETPLACE.DESCRIPTION")}),a(j,{type:"text",placeholder:"Your post",maxLength:250,rows:5,onChange:t=>p({...e,description:t.target.value})})]}),a("div",{className:"item",children:r("div",{className:"images",children:[(e==null?void 0:e.attachments)&&e.attachments.length>0&&e.attachments.map((t,P)=>a("div",{className:"image",style:{backgroundImage:`url(${t})`},onClick:()=>{p({...e,attachments:e.attachments.filter((n,h)=>h!==P)})}},P)),(!(e!=null&&e.attachments)||((w=e==null?void 0:e.attachments)==null?void 0:w.length)<=3)&&a("div",{className:"image",onClick:()=>{var t,P,n;R.Gallery.set({allowExternal:(n=(P=(t=U)==null?void 0:t.value)==null?void 0:P.AllowExternal)==null?void 0:n.MarketPlace,onSelect:h=>p({...e,attachments:[...(e==null?void 0:e.attachments)??[],h.src]})})},children:a(I,{})})]})}),r("div",{className:"item",children:[a("div",{className:"title",children:s("APPS.MARKETPLACE.PRICE")}),a(K,{type:"number",placeholder:"0",onChange:t=>{if(!t.target.value.match(/^[0-9]*$/))return t.preventDefault();p({...e,price:parseFloat(t.target.value)})}})]}),a("div",{className:"button",onClick:()=>X(),children:s("APPS.MARKETPLACE.POST")})]})]})]})}const Y=({post:l,last:L,deletePost:M,isAdmin:O})=>{N(f.Settings);const E=N(f.PhoneNumber),A=N(U),C=c.useRef(null),o=c.useRef(null),[e,p]=c.useState(0),u={pos:{startLeft:0,startX:0},onMouseDown:i=>{u.pos={startLeft:o.current.scrollLeft,startX:i.clientX},o.current.style.userSelect="none",document.addEventListener("mouseup",u.onMouseUp),document.addEventListener("mousemove",u.onMove)},onMove:i=>{const d=(i.clientX-u.pos.startX)/b();o.current.scrollLeft=u.pos.startLeft-d;const m=o.current.getBoundingClientRect();(m.left*b()-5>i.clientX||i.clientX>m.right*b()-5)&&u.onMouseUp()},onMouseUp:()=>{o.current.style.removeProperty("user-select"),document.removeEventListener("mouseup",u.onMouseUp),document.removeEventListener("mousemove",u.onMove);const i=l.attachments,d=o.current.clientWidth;let m=e;const g=o.current.scrollLeft-u.pos.startLeft;g>d/2&&m<i.length-1?m++:g<-d/2&&m>0&&m--,S(m)}},S=i=>{o.current.scrollTo({left:i*o.current.offsetWidth,behavior:"smooth"}),p(i)};return r("div",{className:"post",id:L,ref:C,children:[a("div",{className:"images",ref:o,onMouseDown:u.onMouseDown,children:l.attachments&&l.attachments.map((i,d)=>a("div",{className:"image",children:a("img",{src:i,onClick:()=>R.FullscreenImage.set({display:!0,image:i})})},d))}),r("div",{className:"post-info",children:[r("div",{className:"post-header",children:[a("div",{className:"price",children:A.CurrencyFormat.replace("%s",G(l.price))}),l.attachments&&l.attachments.length>1&&a("div",{className:"scroll-dots",children:l.attachments.map((i,d)=>a("div",{className:`dot ${e==d&&"active"}`,onClick:()=>S(d)},d))})]}),r("div",{className:"post-content",children:[r("div",{className:"title",children:[l.title,r("div",{className:"date",children:["• ",q(l.timestamp)]})]}),a("div",{className:"description",children:B(l.description)}),r("div",{className:"buttons",children:[E!==l.number&&a("div",{className:"button",onClick:()=>{window.postMessage({data:{number:l.number,popUp:!0},action:"phone:contact"})},children:s("APPS.MARKETPLACE.CONTACT")}),(O||l.number===E)&&a("div",{className:"button red",onClick:()=>M(l.id),children:s("APPS.MARKETPLACE.REMOVE")})]})]})]})]})};export{ee as default};
