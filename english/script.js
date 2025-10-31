// Define an 'ENUM' equivalent to store possible values
const SECTIONS = Object.freeze({
    CAM: {
        name: 'CAM',
        element: 'menu-item-cam',
        path: 'cam/kit',
        fileName: 'index.htm',
    },
    POS: {
        name: 'POS',
        element: 'menu-item-pos',
        path: 'pp',
        fileName: 'index.html',
    },
    RPP: {
        name: 'RPP',
        element: 'menu-item-rpp',
        path: 'ce',
        fileName: 'index.html',
    },
    SIM: {
        name: 'SIM',
        element: 'menu-item-sim',
        path: 'vm',
        fileName: 'index.html',
    },
    UI: {
        name: 'UI',
        element: 'menu-item-ui',
        path: 'ui',
        fileName: 'index.html',
    },
    HOME: {
        name: 'HOME',
        element: 'menu-item-home',
        path: undefined,
        fileName: 'index.html',
    },
    RELEASE: {
        name: 'RELEASE',
        element: 'menu-item-release',
        path: 'relnotes',
        fileName: 'index.html',
    },
});

const HIDDEN_CLASS_NAME = 'hidden';

const setSelectedMenuItem = (doc) => {
    const PURE_CSS_SELECTED_ITEM = 'pure-menu-selected';
    for (const key in SECTIONS) {
        const elem = document.getElementById(SECTIONS[key]?.element);
        elem.classList?.remove(PURE_CSS_SELECTED_ITEM);
    }
    const selectedElem = document.getElementById(SECTIONS[doc]?.element);
    selectedElem.classList?.add(PURE_CSS_SELECTED_ITEM);
};

const switchContentDocument = (selection) => {
    window.history.pushState({ page: selection }, '', `?doc=${selection}`);
    setFrameDocument();
};

const createIFrame = (src) => {
    const iframeContainer = document.getElementById('iframe-container');
    const iframe = document.createElement('iframe');
    iframe.setAttribute('src', src);
    iframe.setAttribute('class', 'document-container');
    iframe.setAttribute('frameBorder', '0');
    iframeContainer.appendChild(iframe);
};

const deleteAllIFrames = () => {
    const iframeContainer = document.getElementById('iframe-container');
    // Clear all children (iframes) from the iframe container
    // There should only be one at any moment but better safe than sorry
    while (iframeContainer.firstChild) {
        iframeContainer.removeChild(iframeContainer.lastChild);
    }
};

const setFrameDocument = () => {
    // 1st step, General maintenenance. Hide things by default then display what is selected
    deleteAllIFrames();
    
    // Hide the main navigator index when switching between documentation
    const navigator = document.getElementById('navigator');
    navigator.classList.add(HIDDEN_CLASS_NAME);

    // Let the URL dictate what document is displayed
    const urlParams = new URLSearchParams(window.location.search);
    const doc = urlParams.get('doc') ?? 'HOME';
    const path = urlParams.get('path');

    setSelectedMenuItem(doc);

    if (doc && doc !== SECTIONS.HOME.name) {
        createIFrame(`${SECTIONS[doc]?.path}/${path ?? SECTIONS[doc]?.fileName}`);
    } else {
        navigator.classList.remove(HIDDEN_CLASS_NAME);
    }
};

// handle clicking the back and forward buttons in the browser (this does not apply to the iframe that holds the docs)
window.onpopstate = setFrameDocument;
