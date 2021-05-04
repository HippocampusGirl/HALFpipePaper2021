\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{lea}

\RequirePackage[utf8]{inputenc}

\RequirePackage[english]{babel}

\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage{regexpatch}

\newif\if@reqslineno
\DeclareOption{lineno}{\@reqslinenotrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ExecuteOptions{}
\ProcessOptions\relax
\LoadClass[9pt]{extarticle}

\RequirePackage{amsmath}
\RequirePackage{mdframed}

\RequirePackage{lineno}
\if@reqslineno\linenumbers\fi

\RequirePackage{xstring}

%%
%% Metadata
%%

\newcommand{\org@leftitle}{}% LATEX-Check
\let\org@maketitle\maketitle
\def\maketitle{%
	\hypersetup{
		pdftitle={\@Title},
		pdfsubject={\@abstract},
		pdfkeywords={\@keyword},
		pdfauthor={\@AuthorNames}
		}%
	\org@maketitle
}

%%
%% Fonts
%%

\RequirePackage{unicode-math}

\setmainfont{IBMPlexSerif}[
  Ligatures = TeX,
  Extension = .ttf,
  UprightFont = *-Text,
  BoldFont = *-Bold,
  ItalicFont = *-TextItalic,
  BoldItalicFont = *-BoldItalic,
  FontFace={mb}{n}{*-Medium},
  FontFace={mb}{it}{*-MediumItalic},
  Scale = 1.0
]

%\setmainfont{SourceSerifPro}[
%  Extension = .otf,
%  UprightFont = *-Regular,
%  BoldFont = *-Bold,
%  ItalicFont = *-It,
%  BoldItalicFont = *-BoldIt
%]

\setsansfont{HelveticaNeueLTStd}[
  Extension = .otf,
  UprightFont=*-Roman,
  ItalicFont=*-It,
  BoldFont=*-Bd,
  BoldItalicFont=*-BdIt,
  FontFace={xl}{n}{*-UltLt},
  FontFace={xl}{it}{*-UltLtIt},
  FontFace={l}{n}{*-Lt},
  FontFace={l}{it}{*-LtIt},
  FontFace={mb}{n}{*-Md},
  FontFace={mb}{it}{*-MdIt},
  FontFace={k}{n}{*-Blk},
  FontFace={k}{it}{*-BlkIt},
]

\setmonofont{EssentialPragmataPro}[
  Scale = 0.95
]

\setmathfont{XITSMath-Regular}[
  Extension = .otf, 
  BoldFont = XITSMath-Bold
]

\newfontfamily{\plexsans}{IBMPlexSans}[
  Ligatures = TeX,
  Extension = .ttf,
  UprightFont = *-Text,
  BoldFont = *-Bold,
  ItalicFont = *-TextItalic,
  FontFace={c}{n}{*Condensed-Regular},
  FontFace={c}{it}{*Condensed-Italic},
  Scale = 1.0
]

\newfontfamily{\emoji}{AppleColorEmoji}[
  Extension = .ttf,
  Renderer = HarfBuzz%
]

\RequirePackage{microtype}

\linespread{1.2}

%%
%% Colors
%%

\RequirePackage{graphicx}
\RequirePackage[table,svgnames]{xcolor}

\definecolor{leaPurple}{HTML}{6E4FFC}
\definecolor{leaGrey}{HTML}{A6A6A6}
\colorlet{leaLightGrey}{leaGrey!15}
\definecolor{leaLightGreen}{HTML}{D8EBCD}
\definecolor{leaLightYellow}{HTML}{FFF2CC}

\definecolor{eLifeLightBlue}{HTML}{0A9DD9}
\definecolor{eLifeMediumGrey}{HTML}{6D6E70}
\definecolor{eLifeLightGrey}{HTML}{929497}

%%
%% Layout
%%

\RequirePackage{booktabs}
\RequirePackage{authblk}[noblocks]

\reversemarginpar
\RequirePackage[
  left=1.5cm,  
  right=1.3cm,
  top=2.5cm,
  bottom=2.5cm,
  marginparwidth=4cm,
  marginparsep=0.5cm,
  includemp,reversemp,
  a4paper
]{geometry}

\RequirePackage{changepage}

\RequirePackage{silence}

\RequirePackage[
  labelfont={sf,bf},
  font={sf},
  labelsep=period,
  justification=raggedright,
  singlelinecheck=false,
  tableposition=top
]{caption}
                
% \captionsetup*[table]{skip=\medskipamount}

%%
%% Bibliography
%%

\RequirePackage[
  style=apa,
  block=ragged
]{biblatex}

\setlength{\bibhang}{11pt}
\renewcommand{\bibfont}{\footnotesize}

%%
%% Headers and footers
%%

\RequirePackage{fancyhdr}  % custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document

\pagestyle{fancy}          % Enables the custom headers/footers

\addtolength{\headwidth}{\marginparsep}
\addtolength{\headwidth}{\marginparwidth} 
% \addtolength{\headwidth}{1cm}

% \rfoot{\small\color{eLifeMediumGrey}\thepage\space of\space\pageref{LastPage}}%

\renewcommand{\headrulewidth}{0.2pt}
\xpretocmd\headrule{\color{leaPurple}}{}{\PatchFailed}

\renewcommand{\footrulewidth}{0.2pt}
\xpretocmd\footrule{\color{leaPurple}}{}{\PatchFailed}


%%
%% Section/subsection/paragraph set-up
%%

\setcounter{secnumdepth}{0}

\RequirePackage[explicit]{titlesec}

\titleformat{\section}
  {\sffamily\fontseries{mb}\Large}
  {\thesection}{}{#1}[]

\titleformat{\subsection}
  {\color{eLifeMediumGrey}\large\fontseries{mb}\sffamily}
  {\thesubsection}{}{#1}[]
 
\titleformat{\paragraph}[runin]
  {\vspace{1mm}\color{eLifeMediumGrey}\fontseries{mb}\sffamily}
  {\theparagraph}{0em}{#1} 

\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{0pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
%\titlespacing*{\paragraph}{0pc}{3ex \@plus4pt \@minus3pt}{0pt}
\titlespacing{\paragraph}{0pc}{1mm}{0.5em}
  
\RequirePackage{enumitem}
\setlist{noitemsep}

\RequirePackage{alphalph}
\newalphalph{\fnsymbolmult}[mult]{\@fnsymbol}{5}

\newcounter{authorfn}
\setcounter{authorfn}{1}
\newcommand{\authfn}[1]{%
  \fnsymbolmult{\numexpr\value{authorfn}+#1}%
}


%%
%% Custom title page 
%%

\RequirePackage[many]{tcolorbox}

\newtcolorbox{affilfloat}[1][b]{
  arc=0pt,
  outer arc=0pt,
  boxsep=0pt,left=0pt,right=0pt,top=0pt,bottom=0pt,
  boxrule=0pt,
  colframe=white,
  opacityframe=0,
  colback=white,
  opacityback=0,
  fontupper=\small\sffamily\raggedright\mdseries,
  float=#1
}

%\newcommand{\org@author}{}% LATEX-Check
%\let\org@author\author
%\renewcommand{\author}[1]{\org@author{\mbox{#1}}}

\renewcommand{\Authfont}{\sffamily\fontseries{mb}\large\raggedright}
\renewcommand{\Affilfont}{\mdseries\small\raggedright}
\renewcommand{\AB@authnote}[1]{\textsuperscript{\fontseries{m}#1}}
\renewcommand{\AB@affilnote}[1]{\smash{\textsuperscript{\fontseries{m}#1}}}
\renewcommand{\Authands}{, }
%%\setlength{\affilsep}{16pt}
\setlength{\affilsep}{\baselineskip}
\renewcommand{\AB@affilsepx}{; \protect\Affilfont}

\patchcmd{\@author}{%
  \AB@authlist\\[\affilsep]\AB@affillist
}{%
  \AB@authlist\\[\affilsep] 
}{}{}

\newmdenv[
  topline=false,
  bottomline=false,
  rightline=false,
  leftmargin=-10pt,
  rightmargin=0pt,
  innertopmargin=0pt,
  innerbottommargin=0pt,
  linecolor=leaPurple,
  linewidth=2pt,
]{lealineleft}

\renewcommand{\maketitle}{%
  \thispagestyle{empty}%
  {%
    \begin{lealineleft}%
    {\color{leaPurple}\raggedright\sffamily\fontseries{mb}\fontsize{24}{22}\selectfont \@title\par}%
    \vskip12pt%
    {\@author\par}%
    \end{lealineleft}%
    \vskip4pt%
  }%
  \begin{affilfloat}\Affilfont\selectfont\AB@affillist\end{affilfloat}
}%

\renewenvironment{abstract}{%
   \setlength{\parindent}{0pt}\raggedright
   \fontseries{mb}\selectfont
}{%   
  \vskip4pt
}

%% Insert a grey line to separate floats from main text
\newcommand{\topfigrule}{\vskip8pt\noindent{\rule{\linewidth}{0.5pt}}}
\newcommand{\botfigrule}{\noindent{\rule{\linewidth}{0.5pt}}\vskip8pt}

\RequirePackage{newfloat}
\RequirePackage{wrapfig}
\AtEndEnvironment{wrapfigure}{\vskip8pt\noindent{\rule{\hsize}{1pt}}}
% \RequirePackage[lflt]{floatflt}
% \AtEndEnvironment{floatingfigure}{\vskip8pt\noindent\textcolor{eLifeMediumGrey}{\rule{\hsize}{2pt}}}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{-4.5cm}{}
}{%
  \end{adjustwidth}
}

\newenvironment{morewidth}{%
  \begin{adjustwidth}{-1.6cm}{}
}{%
  \end{adjustwidth}
}

% \appto{\appendix}{%
%   \captionsetup*[figure]{name={Appendix \arabic{appendix} Figure },font={color=leaPurple,small},skip=\smallskipamount}%
%   \captionsetup*[table]{name={Appendix \arabic{appendix} Table },font={color=leaPurple,small}}%
% }

\newcounter{appendix}
\setcounter{appendix}{0}
\newenvironment{appendixbox}{%
  \setcounter{figure}{0}
  \setcounter{table}{0}
  \refstepcounter{appendix}%X[c,m]
  \clearpage%
  \patchcmd{\ttlf@section}{eLifeMediumGrey}{leaPurple}{}{}
  \noindent{\bfseries\Large\color{eLifeMediumGrey}Appendix \arabic{appendix}\par}
  \nolinenumbers%
  \begin{mdframed}[hidealllines=true,backgroundcolor=eLifeLightBlue!10,fontcolor=leaPurple,leftline=true,linecolor=eLifeLightBlue,linewidth=1em]
  \if@reqslineno\addtolength{\linenumbersep}{2em}\internallinenumbers\fi
}{%
  \end{mdframed}
}

\RequirePackage[
  colorlinks=true,
  allcolors=black,
  citecolor=eLifeMediumGrey,
  linkcolor=eLifeMediumGrey,
  urlcolor=leaPurple
]{hyperref}
\urlstyle{same}

%%
%% Boxes
%%

%\RequirePackage{varioref}
%\RequirePackage{cleveref}

\newtcolorbox[
  auto counter
]{featurebox}[2][]{
  arc=0pt,
  outer arc=0pt,
  left=2mm,right=2mm,top=2mm,bottom=2mm,
  toptitle=2mm,
  boxsep=0mm,
  boxrule=0pt,
  colframe=white,
  opacityframe=0,
  colback=leaLightYellow,
  colbacktitle=leaLightYellow,
  coltitle=black,
  fonttitle=\fontseries{mb}\sffamily,
  fontupper=\small\sffamily,
  oversize,
  enlarge left by=-1.6cm,
  width=\linewidth+1.6cm,
  float=t,
  title=Box \thetcbcounter: #2,
  #1
}

\RequirePackage{tabularx,booktabs,array,multirow,makecell}
\RequirePackage{colortbl}
\RequirePackage{collcell}
\RequirePackage{hhline}

\newtcolorbox[
  auto counter
]{tablebox}[2][]{
  arc=0pt,
  outer arc=0pt,
  boxsep=0pt,left=0pt,right=0pt,bottom=0pt,
  top=2mm,
  boxrule=0pt,
  colframe=white,
  opacityframe=0,
  colback=white,
  opacityback=0,
  coltitle=black,
  fonttitle=\fontseries{mb}\sffamily,
  fontupper=\small\sffamily,
  oversize,
  enlarge left by=-1.6cm,
  width=\linewidth+1.6cm,
  float=tb,
  title=Table \thetcbcounter: #2,
  #1
}

%%
%% Custom definitions
%%

\RequirePackage{transparent}
\RequirePackage{soul}

\newcommand{\soft}[1]{%
\smash{\ttfamily\texttransparent{0.15}{%
\begingroup\fboxsep=1pt%
\colorbox{leaGrey}{\texttransparent{1}{#1}}%
\endgroup}}}

\newcommand{\filename}[1]{%
\smash{\ttfamily\texttransparent{0.70}{%
\begingroup\fboxsep=1pt%
\colorbox{leaLightGreen}{\texttransparent{1}{#1}}%
\endgroup}}}

\newcommand{\code}[1]{%
\smash{\ttfamily\texttransparent{0.70}{%
\begingroup\fboxsep=1pt%
\colorbox{leaLightYellow}{\texttransparent{1}{#1}}%
\endgroup}}}

\newcommand{\pseudocode}[1]{
\smash{\plexsans\fontseries{c}\selectfont\texttransparent{0.70}{%
\begingroup\fboxsep=1pt%
\colorbox{leaLightYellow}{\texttransparent{1}{#1}}%
\endgroup}}}

\newcommand{\term}[1]{\emph{#1}}

\newcommand{\envelope}{{\emoji✉️}}

% orcid
\RequirePackage{academicons}
\newcommand{\orcid}[1]{\href{https://orcid.org/#1}{\textcolor[HTML]{B8C624}{\aiOrcid}}}

% autoref
\let\oldautoref\autoref
\renewcommand{\autoref}[1]{\emph{\textbf{\oldautoref{#1}}}}

% underline
% https://alexwlchan.net/2017/10/latex-underlines/
\RequirePackage{contour}
\RequirePackage[normalem]{ulem}

\renewcommand{\ULdepth}{1.2pt}
\contourlength{0.6pt}

\newcommand{\myuline}[1]{%
  \uline{\phantom{#1}}%
  \llap{\contour{white}{#1}}%
}
